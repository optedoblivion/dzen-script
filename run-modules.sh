#!/bin/sh

## Some basic colors
FG='#EEEEEE'
BG='#111111'
FONT='-*-clean-*-*-*-*-12-*-*-*-*-*-*-*'
SEP="  "
MODULEPATH="$HOME/.dzen2/modules"
ICONPATH="$HOME/.dzen2/assets/xbm"
NOTIFYICONPATH="$HOME/.dzen2/notify_icons"
COLOR_CLEAR="^fg()"


## Handle module reloading for plug n play modules
RELOAD_TICK=$(date +"%s")
RELOAD_DURATION=5

while true ; do
    #dt=`date +"%I:%M %a, %x"`
    ## Build list of modules
    TICK=$(date +"%s")
    let TICK=$TICK-$RELOAD_DURATION    
    if [ $TICK -ge $RELOAD_TICK ]; then
        MODULES=$(ls $MODULEPATH)
        RELOAD_TICK=$TICK
    fi
    BAR=""
    for module in $(echo $MODULES);
    do
        source "$MODULEPATH/$module"
        BAR="$(run)$COLOR_CLEAR$SEP$BAR"
    done
    echo $BAR
    sleep 1
done | dzen2 -h '16' -ta r -fg $FG -bg $BG -fn $FONT 

