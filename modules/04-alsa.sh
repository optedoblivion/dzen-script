## ALSA monitoring module ##

## Colors
COLOR_MUTE="^fg(red)"

function run() {

    ismute=$(amixer get Master|grep %|awk '{ print $6 }'|sed 's/\[//g'|sed 's/\]//g'|uniq)
    if [ "$ismute" == "off" ]; then
        VBS="0"
        VICO="^i($ICONPATH/spkr_02.xbm)" 
        COLOR="$COLOR_MUTE"
    else
        VBS=$(amixer get Master|grep %|awk '{ print $4 }'|sed 's/%//g'|sed 's/\[//g'|sed 's/\]//g')
        VICO="^i($ICONPATH/spkr_01.xbm)" 
    fi

    VBAR="$VBS%"
    echo "$COLOR$VICO $VBAR"

}
