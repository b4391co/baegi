#!/bin/sh

IFACE=$(/usr/sbin/ifconfig | grep enp65s0 | awk '{print $1}' | tr -d ':')
if [ "$IFACE" = "enp65s0" ]; then
    IP=$(ifconfig enp65s0 | grep "inet " | awk '{print $2}')
    if [ "$IP" != "" ]; then
        echo "%{F#2495e7} eth: %{F#ffffff}$(/usr/sbin/ifconfig enp65s0 | grep "inet " | awk '{print $2}')%{u-}"
    else
        echo "%{F#2495e7} eth: %{F#e62210}Disconnected"
    fi
else
    echo "%{F#2495e7} eth: %{F#e62210}Disconnected"
fi
