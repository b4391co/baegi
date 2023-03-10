#!/bin/sh

IFACE=$(/usr/sbin/ifconfig | grep tun0 | awk '{print $1}' | tr -d ':')
if [ "$IFACE" = "tun0" ]; then
    IP=$(ifconfig tun0 | grep "inet " | awk '{print $2}')
    if [ "$IP" != "" ]; then
        echo "%{F#2495e7} tun: %{F#ffffff}$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')%{u-}"
    else
        echo "%{F#2495e7} tun: %{F#e62210}Disconnected"
    fi
else
    echo "%{F#2495e7} tun: %{F#e62210}Disconnected"
fi
