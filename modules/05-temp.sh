## Temp module ##

## Colors
COLOR_TEMP_COOL="^fg(blue)"
COLOR_TEMP_HOT="^fg(red)"

function run() {
    CRIT=$(sensors|grep Physical|awk '{ print $12 }'|cut -d '.' -f 1|sed s/+//g)
    HIGH=$(sensors|grep Physical|awk '{ print $8 }'|cut -d '.' -f 1|sed s/+//g)
    TMP=$(sensors|grep Physical|awk '{ print $4 }'|cut -d '.' -f 1|sed s/+//g)
    ICO="^i($ICONPATH/temp.xbm)"
    COLOR="$COLOR_TEMP_COOL"
    if [ $TMP -ge $HIGH ]; then
        COLOR="$COLOR_TEMP_HOT"
    fi
    echo "$COLOR$ICO $TMP°C$COLOR_CLEAR"
}
