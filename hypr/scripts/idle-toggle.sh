#!/bin/bash

# Genmon script for toggling hypridle profiles

# --- Configuration ---
STATE_FILE="/tmp/hypridle_mode"
CURRENT_MODE=$(cat "$STATE_FILE" 2>/dev/null || echo "hibernate")

# --- Profiles ---
# Configurations are managed via symlinks in ~/.config/hypr/
# hypridle.conf will be symlinked to hypridle-hibernate.conf, hypridle-hibernate-ram.conf, or hypridle-focus.conf

# --- Functions ---

# Function to start hypridle
start_hypridle() {
    # Ensure DBUS_SESSION_BUS_ADDRESS is available for hypridle
    # This is often needed when running from a non-login shell like genmon
    if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
        # Attempt to find the DBus session address
        # This is a common way to get it for user services
        DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $UID gnome-session | head -n 1)/environ | cut -d= -f2-)
        export DBUS_SESSION_BUS_ADDRESS
    fi
    hypridle &
}

# Function to kill existing hypridle instance
kill_hypridle() {
    pkill -f hypridle
}

# --- Main Logic ---

# If the script is called with an argument, it's a click action
if [ -n "$1" ]; then
    case "$CURRENT_MODE" in
        "hibernate")
            NEXT_MODE="hibernate-ram"
            ;;
        "hibernate-ram")
            NEXT_MODE="focus"
            ;;
        "focus")
            NEXT_MODE="hibernate"
            ;;
        *) # Default to hibernate if state is somehow invalid
            NEXT_MODE="hibernate"
            ;;
    esac
    echo "$NEXT_MODE" > "$STATE_FILE"
    CURRENT_MODE="$NEXT_MODE"

    # Apply the new mode
    kill_hypridle
    case "$CURRENT_MODE" in
        "hibernate")
            ln -sf ~/.config/hypr/hypridle-hibernate.conf ~/.config/hypr/hypridle.conf
            start_hypridle
            ;;
        "hibernate-ram")
            ln -sf ~/.config/hypr/hypridle-hibernate-ram.conf ~/.config/hypr/hypridle.conf
            start_hypridle
            ;;
        "focus")
            ln -sf ~/.config/hypr/hypridle-focus.conf ~/.config/hypr/hypridle.conf
            # Do nothing, hypridle is already killed
            ;;
    esac
fi

# --- Genmon Output ---

ICON=""
TOOLTIP=""

case "$CURRENT_MODE" in
    "hibernate")
        ICON="3floppy_mount" # hibernate
        TOOLTIP="Idle: hibernate"
        ;;
    "hibernate-ram")
        ICON="media-memory" # hibernate-ram
        TOOLTIP="Idle: hibernate-ram"
        ;;
    "focus")
        ICON="stock_lock-open" # disabled
        TOOLTIP="Idle: disabled"
        ;;
esac

# Check if hypridle is running (for visual feedback)
if ! pgrep -f hypridle > /dev/null && [ "$CURRENT_MODE" != "focus" ]; then
    ICON="dialog-error-symbolic"
    TOOLTIP="Error: hypridle not running!"
fi


echo "<icon>$ICON</icon>"
echo "<tool>$TOOLTIP</tool>"
# Pass the script's own path to the click handler
echo "<iconclick>$0 click</iconclick>"
