#!/bin/sh
 
# echo "%{F#F90C0C}󰖂 tun0:%{F#ffffff}$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')%{u-} || echo 'Not online'"

echo "%{F#1bbf3e $(acpi | awk '{print $4}'| awk -F ',' '{print $1}') %{F#ffffff}"
