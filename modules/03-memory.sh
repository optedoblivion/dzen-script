## Memory module ##

## Colors
COLOR_CRITICAL="^fg(red)"

function run() {
    MAX=$(free -m | grep Mem | awk '{ print $2 }')
    USE=$(free -m | grep Mem | awk '{ print $3 }')
    PLUSMINUS=$(free -m | grep "\-/+" | awk '{ print $3 }')
    USE=$(echo "$USE - $PLUSMINUS" | bc -q 2>/dev/null)
    PERCENT=$(echo "scale=2; ($USE/$MAX) * 100" | bc -q 2>/dev/null)
    PERCENT=$(echo "$PERCENT" | cut -d '.' -f 1)
    ICO="^i($ICONPATH/mem.xbm)"
    if [ $PERCENT -gt 90 ]; then
        COLOR="$COLOR_ERROR"
    fi
    PERCENT="$PERCENT%"
    echo "$COLOR$ICO $PERCENT"
}
