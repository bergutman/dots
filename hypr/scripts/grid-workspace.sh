#!/bin/bash
# Hyprland Grid Workspace Script
# Manages row-based workspace grid where SUPER+1-9 always refers to the current row
# Workspace IDs are numeric (1-90) but display as A1-10, B1-10, etc.

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr-grid"
STATE_FILE="$STATE_DIR/current-row"
ROWS_AVAILABLE=9  # Maximum number of rows (A-I)

# Ensure state directory exists
mkdir -p "$STATE_DIR"

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "0" > "$STATE_FILE"
fi

get_current_row() {
    # Always calculate from active workspace to stay in sync
    local ws_id=$(hyprctl activeworkspace -j | jq -r '.id')
    # Row calculation: (ws_id - 1) / 10 gives correct row
    # E.g., ws 1-10 -> row 0, ws 11-20 -> row 1, etc.
    echo $(( (ws_id - 1) / 10 ))
}

set_row() {
    local new_row=$1
    if [ "$new_row" -lt 0 ]; then
        new_row=0
    elif [ "$new_row" -ge "$ROWS_AVAILABLE" ]; then
        new_row=$((ROWS_AVAILABLE - 1))
    fi
    echo "$new_row" > "$STATE_FILE"
    echo "$new_row"
}

get_workspace_id() {
    # $1 = row, $2 = column (1-10)
    local row=$1
    local col=$2
    # Map to numeric ID: Row A (0) = 1-10, Row B (1) = 11-20, etc.
    echo $((row * 10 + col))
}

get_current_column() {
    # Get current workspace ID and extract column
    local ws_id=$(hyprctl activeworkspace -j | jq -r '.id')
    # Column calculation: ((ws_id - 1) % 10) + 1 gives 1-10
    # E.g., ws 1 -> col 1, ws 10 -> col 10, ws 11 -> col 1
    echo $(( (ws_id - 1) % 10 + 1 ))
}

set_animation() {
    # $1 = "vert" for vertical, "horiz" for horizontal
    if [ "$1" = "vert" ]; then
        hyprctl keyword animation "workspaces,1,5,overshot,slidevert" >/dev/null 2>&1
    else
        hyprctl keyword animation "workspaces,1,5,overshot,slide" >/dev/null 2>&1
    fi
}

case "$1" in
    goto)
        # Go to workspace in current row: $1 = goto, $2 = workspace (1-10)
        ws_idx=$2
        current_row=$(get_current_row)
        ws_id=$(get_workspace_id $current_row $ws_idx)
        set_animation "horiz"
        hyprctl dispatch workspace "$ws_id"
        ;;
    move)
        # Move window to workspace in current row: $1 = move, $2 = workspace (1-10)
        ws_idx=$2
        current_row=$(get_current_row)
        ws_id=$(get_workspace_id $current_row $ws_idx)
        set_animation "horiz"
        hyprctl dispatch movetoworkspace "$ws_id"
        ;;
    row-up)
        # Move up one row
        current_row=$(get_current_row)
        if [ "$current_row" -gt 0 ]; then
            new_row=$((current_row - 1))
            set_row "$new_row"
            # Move to the same column in the new row
            current_col=$(get_current_column)
            new_ws=$(get_workspace_id $new_row $current_col)
            set_animation "vert"
            hyprctl dispatch workspace "$new_ws"
        fi
        ;;
    row-down)
        # Move down one row
        current_row=$(get_current_row)
        if [ "$current_row" -lt $((ROWS_AVAILABLE - 1)) ]; then
            new_row=$((current_row + 1))
            set_row "$new_row"
            # Move to the same column in the new row
            current_col=$(get_current_column)
            new_ws=$(get_workspace_id $new_row $current_col)
            set_animation "vert"
            hyprctl dispatch workspace "$new_ws"
        fi
        ;;
    set-row)
        # Jump to specific row: $1 = set-row, $2 = row number
        target_row=$2
        new_row=$(set_row "$target_row")
        current_col=$(get_current_column)
        new_ws=$(get_workspace_id $new_row $current_col)
        set_animation "vert"
        hyprctl dispatch workspace "$new_ws"
        ;;
    current)
        # Print current row
        get_current_row
        ;;
    *)
        echo "Usage: $0 {goto|move|row-up|row-down|set-row|current} [workspace/row]"
        exit 1
        ;;
esac
