## wifi monitoring module ##

## Colors
COLOR_WIFI_FULL="^fg(green)"
COLOR_WIFI_HALF="^fg(orange)"
COLOR_WIFI_LOW="^fg(red)"

run() {
    MAX="255"
    SIGNAL=$(iwconfig wlp2s0 | grep Signal | cut -d '=' -f 3 | awk '{ print $1}' | sed s/-//g)
    PERCENT=$(echo "scale=2; ($SIGNAL/$MAX) * 100" | bc)
    PERCENT=$(echo "$PERCENT" | cut -d '.' -f 1)
    PERCENT=$(echo "100 - $PERCENT" | bc)
    ICO="^i($ICONPATH/wifi_full.xbm)"
    COLOR="$COLOR_WIFI_FULL"
    if [ $PERCENT -lt 66 ]; then 
        ICO="^i($ICONPATH/wifi_half.xbm)"
        COLOR="$COLOR_WIFI_HALF"
        if [ $PERCENT -lt 33 ]; then
            ICO="^i($ICONPATH/wifi_low.xbm)"
            COLOR="$COLOR_WIFI_LOW"
        fi
    fi
    echo "$COLOR$ICO $PERCENT%"
}
