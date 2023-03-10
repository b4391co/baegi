#!/bin/sh

IFACE=$(/usr/sbin/ifconfig | grep rpi0 | awk '{print $1}' | tr -d ':')
if [ "$IFACE" = "rpi0" ]; then
    IP=$(ifconfig rpi0 | grep "inet " | awk '{print $2}')
    if [ "$IP" != "" ]; then
        echo "%{F#2495e7} rpi: %{F#ffffff}$(/usr/sbin/ifconfig rpi0 | grep "inet " | awk '{print $2}')%{u-}"
    else
        echo "%{F#2495e7} rpi: %{F#e62210}Disconnected"
    fi
else
    echo "%{F#2495e7} rpi: %{F#e62210}Disconnected"
fi
