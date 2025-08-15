#!/bin/bash

<<COMMENT
   XFCE4 Genmon Plugin Script for NetworkManager Status
   
   This script creates a panel widget that displays network connection status.
   It detects NetworkManager connections and shows appropriate icons based on:
   - Connection type (ethernet, wifi, none)
   - WiFi signal strength (excellent, good, fair, poor)
   - Connection status (connected, disconnected, connecting)
   
   Features:
   - Real-time network status monitoring
   - Dynamic icon selection based on connection type and quality
   - Tooltip with detailed connection information
   - Click to open NetworkManager TUI
   
   Usage:
   - Add this script to xfce4-genmon-plugin in your panel
   - Set refresh interval as needed (recommended: 60-120 seconds)
   
   Dependencies:
   - NetworkManager (nmcli)
   - bash
COMMENT

# Get network status using NetworkManager
get_network_status() {
    # Check if NetworkManager is running
    if ! nmcli -t -f STATE general status 2>/dev/null | grep -q .; then
        echo "disconnected"
        return
    fi
    
    # Get active connection using device status
    local active_conn=$(nmcli -t -f DEVICE,TYPE,STATE device status | grep ":connected" | grep -v "loopback" | head -1)
    
    if [[ -z "$active_conn" ]]; then
        echo "disconnected"
        return
    fi
    
    # Parse connection info
    local device=$(echo "$active_conn" | cut -d: -f1)
    local conn_type=$(echo "$active_conn" | cut -d: -f2)
    
    if [[ "$conn_type" == "ethernet" ]]; then
        echo "ethernet"
    elif [[ "$conn_type" == "wifi" ]]; then
        # Get WiFi signal strength for the connected network
        local signal=$(nmcli -t -f DEVICE,SIGNAL device wifi list | grep "^$device:" | head -1 | cut -d: -f2)
        if [[ -n "$signal" && "$signal" =~ ^[0-9]+$ ]]; then
            if [[ $signal -ge 80 ]]; then
                echo "wifi-excellent"
            elif [[ $signal -ge 60 ]]; then
                echo "wifi-good"
            elif [[ $signal -ge 40 ]]; then
                echo "wifi-fair"
            else
                echo "wifi-poor"
            fi
        else
            echo "wifi"
        fi
    else
        echo "connected"
    fi
}

# Get connection details for tooltip
get_connection_details() {
    local active_conn=$(nmcli -t -f DEVICE,TYPE,STATE device status | grep ":connected" | grep -v "loopback" | head -1)
    
    if [[ -z "$active_conn" ]]; then
        echo "No network connection"
        return
    fi
    
    local device=$(echo "$active_conn" | cut -d: -f1)
    local conn_type=$(echo "$active_conn" | cut -d: -f2)
    
    if [[ "$conn_type" == "ethernet" ]]; then
        echo "Ethernet: $device"
    elif [[ "$conn_type" == "wifi" ]]; then
        # Get the connected network info
        local connected_info=$(nmcli -t -f DEVICE,SSID,SIGNAL device wifi list | grep "^$device:" | head -1)
        local ssid=$(echo "$connected_info" | cut -d: -f2)
        local signal=$(echo "$connected_info" | cut -d: -f3)
        if [[ -n "$ssid" && "$signal" =~ ^[0-9]+$ ]]; then
            echo "WiFi: $ssid ($signal%)"
        else
            echo "WiFi: Connected"
        fi
    else
        echo "Connected: $device"
    fi
}

# Main script
STATUS=$(get_network_status)
DETAILS=$(get_connection_details)

# Icon mapping based on status
case $STATUS in
    "ethernet")
        ICON="network-wired"
        ;;
    "wifi-excellent")
        ICON="network-wireless-signal-excellent-symbolic"
        ;;
    "wifi-good")
        ICON="network-wireless-signal-good-symbolic"
        ;;
    "wifi-fair")
        ICON="network-wireless-signal-ok-symbolic"
        ;;
    "wifi-poor")
        ICON="network-wireless-signal-weak-symbolic"
        ;;
    "wifi")
        ICON="network-wireless"
        ;;
    "connected")
        ICON="network-transmit-receive"
        ;;
    *)
        ICON="network-offline"
        ;;
esac

# Genmon output
echo "<icon>$ICON</icon>"
echo "<tool>$DETAILS</tool>"
echo "<iconclick>xfce4-terminal -e 'bash -c \"sleep 0.1 && nmtui\"'</iconclick>"
echo "<txtclick>xfce4-terminal -e 'bash -c \"sleep 0.1 && nmtui\"'</txtclick>"
