#!/bin/sh

IFACE=$(/usr/sbin/ifconfig | grep wlan0 | awk '{print $1}' | tr -d ':')
if [ "$IFACE" = "wlan0" ]; then
    IP=$(ifconfig wlan0 | grep "inet " | awk '{print $2}')
    if [ "$IP" != "" ]; then
        echo "%{F#2495e7} wlan: %{F#ffffff}$(/usr/sbin/ifconfig wlan0 | grep "inet " | awk '{print $2}')%{u-}"
    else
        echo "%{F#2495e7} wlan: %{F#e62210}Disconnected"
    fi
else
    echo "%{F#2495e7} wlan: %{F#e62210}Disconnected"
fi
