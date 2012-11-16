#!/bin/sh

FG='#EEEEEE'
BG='#111111'
FONT='-*-clean-*-*-*-*-12-*-*-*-*-*-*-*'
SEP="  "
GDBW="20"
GDBH="10"
MODULEPATH="$HOME/.dzen2/modules"
ICONPATH="$HOME/.dzen2/assets/xbm"
NOTIFYICONPATH="$HOME/.dzen2/notify_icons"
NORMALCOLOR="^fg()"
ERRORCOLOR="^fg(red)"
CLEARCOLOR="^fg()"
COLOR="$NORMALCOLOR"
COOLTEMPCOLOR="^fg(blue)"
HOTTEMPCOLOR="^fg(red)"

myVol(){
    ismute=$(amixer get Master|grep %|awk '{ print $6 }'|sed 's/\[//g'|sed 's/\]//g')
    if [ "$ismute" == "off" ]; then
        VBS="0"
        VICO="^i($ICONPATH/spkr_02.xbm)" 
        COLOR="$ERRORCOLOR"
    else
        VBS=$(amixer get Master|grep %|awk '{ print $4 }'|sed 's/%//g'|sed 's/\[//g'|sed 's/\]//g')
        VICO="^i($ICONPATH/spkr_01.xbm)" 
    fi

    VBAR=$(echo "$VBS" | gdbar -s v -fg "$FG" -bg gray40 -h $GDBH -w $GDBW|awk '{ print $1 }')
    echo "$COLOR$VICO $VBAR$CLEARCOLOR"

}

myBat(){
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
            COLOR="$ERRORCOLOR"
        fi
    fi
    
    echo "$COLOR$ICO $PERCENT$CLEARCOLOR"
}

myMem(){
    MAX=$(free -m | grep Mem | awk '{ print $2 }')
    USE=$(free -m | grep Mem | awk '{ print $3 }')
    PLUSMINUS=$(free -m | grep "\-/+" | awk '{ print $3 }')
    USE=$(echo "$USE - $PLUSMINUS" | bc -q 2>/dev/null)
    PERCENT=$(echo "scale=2; ($USE/$MAX) * 100" | bc -q 2>/dev/null)
    PERCENT=$(echo "$PERCENT" | cut -d '.' -f 1)
    ICO="^i($ICONPATH/mem.xbm)"
    if [ $PERCENT -gt 90 ]; then
        COLOR="$ERRORCOLOR"
    fi
    PERCENT="$PERCENT%"
    echo "$COLOR$ICO $PERCENT$CLEARCOLOR"
}

myCPU(){
    ICO="^i($ICONPATH/cpu.xbm)"
    PERCENTAGE=$("$MODULEPATH/cpubar")
    PERCENTAGE=$(echo "$PERCENTAGE" | tr -d " ")
    NUM=$(echo $PERCENTAGE | cut -d '%' -f 1)
    if [ $NUM -gt 90 ]; then
        COLOR="$ERRORCOLOR"
    fi
    echo "$COLOR$ICO $PERCENTAGE$CLEARCOLOR"
}

myDisks(){
    ROOTMAX=`df |grep sda3|awk '{ print $2 }'`
    ROOTUSG=`df |grep sda3|awk '{ print $3 }'`
    MYHOMEMAX=`df |grep home|awk '{ print $2 }'`
    MYHOMEUSG=`df |grep home|awk '{ print $3 }'`
    HOMEPER=`echo $MYHOMEUSG|gdbar -w $GDBW -h $GDBH -max $MYHOMEMAX|awk '{ print $1 }'|sed s/\%//`
    ROOTPER=`echo $ROOTUSG|gdbar -w $GDBW -h $GDBH -max $ROOTMAX|awk '{ print $1 }'|sed s/\%//`
    RCOLOR=""
    HCOLOR=""
    if [ "$ROOTPER" -gt 90 ]; then
        RBCOLOR="-fg red"
        RCOLOR="$ERRORCOLOR"
    fi

    if [ "$HOMEPER" -gt 90 ]; then
        HBCOLOR="-fg red"
        HCOLOR="$ERRORCOLOR"
    fi

    HOMEBAR=`echo $MYHOMEUSG|gdbar -w $GDBW -h $GDBH $HBCOLOR -max $MYHOMEMAX|awk '{ print $2 }'`
    ROOTBAR=`echo $ROOTUSG|gdbar -w $GDBW -h $GDBH $RBCOLOR -max $ROOTMAX|awk '{ print $2 }'`
    echo "$RCOLOR root $ROOTBAR$CLEARCOLOR$HCOLOR home $HOMEBAR$CLEARCOLOR"
}

myTemp(){
    MAX=$(sensors|grep temp1|awk '{ print $6 }'|cut -d '.' -f 1|sed s/+//g)
    TMP=$(sensors|grep temp1|awk '{ print $2 }'|cut -d '.' -f 1|sed s/+//g)
    PERCENT=$(echo "scale=2; ($TMP/$MAX) * 100" | bc  )
    PERCENT=$(echo "$PERCENT" | cut -d '.' -f 1)
    ICO="^i($ICONPATH/temp.xbm)"
    COLOR="$COOLTEMPCOLOR"
    if [ $PERCENT -gt 90 ]; then
        notify-send "Temperature Critical" "Cool this bitch down."
        COLOR="$HOTTEMPCOLOR"
    fi
    echo "$COLOR$ICO $TMP°C$CLEARCOLOR"
}

while true ; do
    dt=`date +"%I:%M %a, %x"`
    #echo "$(myDisks)$SEP$(myCPU)$SEP$(myMem)$SEP$(myVol)$SEP$(myTemp)$SEP$(myBat)$SEP$dt"
    echo "$(myVol)$SEP$(myCPU)$SEP$(myMem)$SEP$(myBat)$SEP$(myTemp)$SEP$dt"
    sleep 1
done | dzen2 -h '16' -ta r -fg $FG -bg $BG -fn $FONT 

