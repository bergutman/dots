# Hyprland Configuration

![Screenshot of Hyprland desktop](screenshot.png)

These are my personal configuration files for the Hyprland Wayland compositor and related tools. I am a freak who uses XFCE alongside Hyprland.

## Config Files

-   `hyprland.conf`: The main configuration file for Hyprland. It defines keybindings, window rules, aesthetics, autostart applications, etc.
-   `hypridle.conf`: Configures `hypridle`, which manages idle states. It's set to dim the screen, lock the system, and eventually hibernate after periods of inactivity.
-   `hyprlock.conf`: Configures `hyprlock`, the screen locker. It defines the appearance of the lock screen, including the background and password input field.
-   `hyprsunset.conf`: Configures `hyprsunset`, which adjusts the screen's color temperature based on the time of day to reduce eye strain.
-   `scripts/`: A directory containing helper scripts.
    -   `network-genmon.sh`: A script for the XFCE4 Genmon plugin that displays the current network status (wired, Wi-Fi strength, or disconnected) on the panel.
    -   `workspace-genmon.sh`: A script for the XFCE4 Genmon plugin that displays the active Hyprland workspace and the title of the currently focused window.

## Usage

To use these configurations, place the files in `~/.config/hypr/` and modify to your liking.

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
