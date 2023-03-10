#!/bin/sh

vol=$((`amixer | grep '%' | head --lines=1 | awk -F '[' '{print $2}' | awk -F '%' '{print $1}'`))
if [ $vol -eq 0 ]
then
    echo " 0%"
elif [ $vol -le 50 ]
then
    echo " $vol"%
elif [ $vol -le 100 ]
then
    echo " $vol"%
fi
