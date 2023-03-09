#!/bin/sh

IFACE=$(/usr/sbin/ifconfig | grep enp65s0 | awk '{print $1}' | tr -d ':')
 
if [ "$IFACE" = "enp65s0" ]; then
    echo "%{F#2495e7} eth: %{F#ffffff}$(ifconfig enp65s0 | grep "inet " | awk '{print $2}')"
else
    echo "%{F#2495e7}%{u-} eth: Disconnected"
fi
