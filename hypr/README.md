# Hyprland Configuration

![Screenshot of Hyprland desktop](screenshot.png)

These are my personal configuration files for the Hyprland Wayland compositor and related tools. I am a freak who uses XFCE alongside Hyprland.

## Config Files

-   `hyprland.conf`: The main configuration file for Hyprland. It defines keybindings, window rules, aesthetics, autostart applications, etc.
-   `hypridle-hibernate.conf`: Configures `hypridle` to lock the screen and hibernate the system after a short period of inactivity.
-   `hypridle-hibernate-ram.conf`: Configures `hypridle` to lock the screen and hibernate the system to RAM after a short period of inactivity.
-   `hypridle-lock.conf`: Configures `hypridle` to lock the screen without hibernating after a short period of inactivity.
-   `hypridle-focus.conf`: A `hypridle` configuration for 'focus' mode, which effectively disables idle-related actions.
-   `hyprlock.conf`: Configures `hyprlock`, the screen locker. It defines the appearance of the lock screen, including the background and password input field.
-   `hyprsunset.conf`: Configures `hyprsunset`, which adjusts the screen's color temperature based on the time of day to reduce eye strain.
-   `scripts/`: A directory containing helper scripts.
    -   `grid-workspace.sh`: Implements a grid-based workspace system with row/column navigation.
    -   `idle-toggle.sh`: A script for the XFCE4 Genmon plugin that toggles between the three `hypridle` profiles (hibernate, hibernate-ram, and focus).
    -   `network-genmon.sh`: A script for the XFCE4 Genmon plugin that displays the current network status (wired, Wi-Fi strength, or disconnected) on the panel.
    -   `workspace-genmon.sh`: A script for the XFCE4 Genmon plugin that displays the active Hyprland workspace and the title of the currently focused window.

## Usage

To use these configurations, place the files in `~/.config/hypr/` and modify to your liking. The `hypridle.conf` file is managed via the `scripts/idle-toggle.sh` script, which creates a symlink to one of the three idle profiles.

## Grid Workspace System

My configuration uses a unique grid-based workspace layout organized in rows (A-I) and columns (1-10), providing up to 90 workspaces with intuitive navigation.

### Workspace Naming

Workspaces are named using a letter (row) and number (column) pattern:
- **Row A:** A1, A2, A3, ..., A10
- **Row B:** B1, B2, B3, ..., B10
- **Row C:** C1, C2, C3, ..., C10
- And so on through Row I

Internally, these map to workspace IDs 1-90 (Row A = 1-10, Row B = 11-20, etc.).

### Keybindings

**Horizontal Navigation (within a row):**
- `SUPER + 1-9, 0` → Switch to workspace 1-10 in the current row
- `SUPER + SHIFT + 1-9, 0` → Move focused window to workspace in the current row

**Vertical Navigation (between rows):**
- `SUPER + ]` → Move down one row (e.g., A→B, B→C)
- `SUPER + [` → Move up one row (e.g., C→B, B→A)

### Animations

The grid system uses directional animations:
- **Horizontal slides** for moving within a row (changing columns)
- **Vertical slides** for moving between rows

This creates a spatial sense of navigation - you slide left/right when moving across columns, and up/down when changing rows.

### Script Details

The `scripts/grid-workspace.sh` script handles:
- Calculating the correct workspace ID from row/column position
- Detecting the current row from the active workspace
- Setting appropriate animations based on navigation direction
- Managing row state for navigation

The script requires `jq` for JSON parsing when querying Hyprland's active workspace.

## Dependencies

This configuration relies on the following software:

-   **Compositor and Tools:**
    -   `hyprland`
    -   `hypridle`
    -   `hyprlock`
    -   `hyprsunset`
-   **Panel and Widgets:**
    -   `xfce4-panel`
    -   `xfce4-genmon-plugin`
-   **System Utilities:**
    -   `pactl` (for volume control)
    -   `light` (for screen brightness)
    -   `playerctl` (for media playback control)
    -   `grim` and `slurp` (for screenshots)
    -   `hyprpicker` (for color picking)
    -   `jq` (for JSON processing in scripts)
    -   `NetworkManager` (`nmcli`)
-   **Applications:**
    -   `catfish` (file search)
    -   `xfce4-dict` (dictionary)
    -   `nwg-look` (for GTK theme management)
    -   `xfce4-terminal`
    -   `thunar` (file manager)
    -   `xfce4-popup-whiskermenu`
