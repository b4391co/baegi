ip_address=$(cat ~/.config/polybar/scripts/target | awk '{print $1}')
machine_name=$(cat ~/.config/polybar/scripts/target | awk '{print $2}')
 
if [ $ip_address ] && [ $machine_name ]; then
    echo "%{F#ff0000}${F#ff0000}$ip_address%{u-} - $machine_name"
else
    echo "${F#ff0000}%{u-}%{F#ff0000} No target"
fi
