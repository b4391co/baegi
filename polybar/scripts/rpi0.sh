#!/bin/sh
 
#echo "%{F#F90C0C} rpi0:%{F#ffffff}$(/usr/sbin/ifconfig rpi0 | grep "inet " | awk '{print $2}')%{u-}"

IFACE=$(/usr/sbin/ifconfig | grep rpi0 | awk '{print $1}' | tr -d ':')
 
if [ "$IFACE" = "rpi0" ]; then
    echo "%{F#1bbf3e} rpi0 %{F#ffffff}$(/usr/sbin/ifconfig rpi0 | grep "inet " | awk '{print $2}')%{u-}"
else
    echo "%{F#1bbf3e}%{u-} Disconnected"
fi