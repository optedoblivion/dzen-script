## Battery Module ##

## Colors
COLOR_CRITICAL="^fg(red)"

function run() {
    TIME=""
    STATE=$(acpi | awk '{ print $3 }' | sed s/,//g)
    if [ "$STATE" != "Discharging" ]; then
        PERCENT=$(acpi | awk ' {print $4 }' | sed s/,//g)
        ICO="^i($ICONPATH/ac_01.xbm)"
    else
        PERCENT=$(acpi | awk ' {print $4 }' | sed s/,//g)
        NUM=$(echo $PERCENT|sed s/\%//)
        if [ "$NUM" -gt "75" ]; then
            ICO="^i($ICONPATH/bat_full_01.xbm)"
            BATTERY_CRITICAL=$(ls /tmp|grep battery_critical)
            if [ "$BATTERY_CRITICAL" != "" ]; then
                rm /tmp/battery_critical
            fi
        elif [ "$NUM" -gt "20" ]; then
            ICO="^i($ICONPATH/bat_low_01.xbm)"
            BATTERY_CRITICAL=$(ls /tmp|grep battery_critical)
            if [ "$BATTERY_CRITICAL" != "" ]; then
                rm /tmp/battery_critical
            fi
        else
            ICO="^i($ICONPATH/bat_empty_01.xbm)"
            BATTERY_CRITICAL=$(ls /tmp|grep battery_critical)
            if [ "$BATTERY_CRITICAL" == "" ]; then
                notify-send "Battery Critical" "You battery state is critical $PERCENT left."
                touch /tmp/battery_critical
            fi            
            COLOR="$COLOR_ERROR"
        fi
    fi
    
    echo "$COLOR$ICO $PERCENT"

}
