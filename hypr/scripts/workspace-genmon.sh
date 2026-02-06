#!/bin/bash

<<COMMENT
   XFCE4 Genmon Plugin Script for Hyprland Integrations
   
   This script creates a panel widget that displays information about the currently
   active workspace and focused window in Hyprland. It's designed to be used with
   the xfce4-genmon-plugin in the XFCE4 panel.
   
   Usage:
   - Add this script to xfce4-genmon-plugin in your panel
   - Set refresh interval as needed (recommended: 0.25-0.5 seconds)
   
   Dependencies:
   - hyprctl (from Hyprland)
   - jq (JSON processor)
   - bash
COMMENT

# Convert workspace number to grid format (e.g., 5 → A5, 15 → B5, 25 → C5)
convert_ws_to_grid() {
    local ws_num=$1
    local row=$(( (ws_num - 1) / 10 ))  # 0 for 1-10, 1 for 11-20, etc.
    local col=$(( (ws_num - 1) % 10 + 1 )) # 1-10
    local row_letter=$(printf "%b" "\\x$(printf '%x' "$((65 + row))")") # 0→A, 1→B, etc.
    echo "${row_letter}${col}"
}

# Get active workspace
ACTIVE_WS_NUM=$(hyprctl activeworkspace -j | jq -r '.name')
ACTIVE_WS=$(convert_ws_to_grid "$ACTIVE_WS_NUM")

# Get active window info
WIN_INFO=$(hyprctl activewindow -j)
WIN_TITLE=$(echo "$WIN_INFO" | jq -r '.title')
WIN_CLASS=$(echo "$WIN_INFO" | jq -r '.class')

# Trim long titles (adjust max length as needed)
if [[ ${#WIN_TITLE} -gt 40 ]]; then
    WIN_TITLE="${WIN_TITLE:0:37}..."
fi

# Genmon output
echo "<txt>WS-$ACTIVE_WS - $WIN_TITLE</txt>"
echo "<css>
.genmon_value {font-weight: bold; padding: 0 5px;}
</css>"
