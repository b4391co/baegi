#!/bin/sh

vol=$((`amixer | grep '%' | head --lines=1 | awk -F '[' '{print $2}' | awk -F '%' '{print $1}'`))
status=`amixer | grep 'off' | awk -F '[' '{print $3}' | awk -F ']' '{print $1}' | sort -ru`
if [ "$status" != "" ]
then
    echo "%{F#ff1500} %{F#ffffff}0%"
fi
if [ $vol -eq 0 ]
then
    echo "%{F#2495e7} %{F#ffffff}0%"
elif [ $vol -le 50 ]
then
    echo "%{F#2495e7} %{F#ffffff}$vol"%
elif [ $vol -le 100 ]
then
    echo "%{F#2495e7} %{F#ffffff}$vol"%
fi
