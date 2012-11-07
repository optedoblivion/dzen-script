#!/bin/sh

FG='#EEEEEE'
BG='#111111'
FONT='-*-clean-*-*-*-*-12-*-*-*-*-*-*-*'
SEP="  "
GDBW="20"
GDBH="5"
ICONPATH="$HOME/.dzen2/xbm"
NOTIFYICONPATH="$HOME/.dzen2/notify_icons"
NORMALCOLOR="^fg()"
ERRORCOLOR="^fg(red)"
CLEARCOLOR="^fg()"
COLOR="$NORMALCOLOR"
COOLTEMPCOLOR="^fg(blue)"
HOTTEMPCOLOR="^fg(red)"

myVol(){
    ismute=`amixer get Master|grep %|awk '{ print $6 }'|sed 's/\[//g'|sed 's/\]//g'`
    if [ "$ismute" == "off" ]; then
        VBS="0"
        VICO="^i($ICONPATH/spkr_02.xbm)" 
        COLOR="$ERRORCOLOR"
    else
        VBS=`amixer get Master|grep %|awk '{ print $4 }'|sed 's/%//g'|sed 's/\[//g'|sed 's/\]//g'`
        VICO="^i($ICONPATH/spkr_01.xbm)" 
    fi

    VBAR=`echo "$VBS" | gdbar -fg '#aecf96' -bg gray40 -h $GDBH -w $GDBW|awk '{ print $1 }'`
    echo "$COLOR$VICO $VBAR$CLEARCOLOR"

}

myBat(){
    MAX=`cat /proc/acpi/battery/BAT0/info|grep last|awk '{ print $4 }'`
    CHARGE=`cat /proc/acpi/battery/BAT0/state|grep remaining|awk '{ print $3 }'`
    TIME=""
    STATE=`cat /proc/acpi/battery/BAT0/state |grep charging|awk '{ print $3 }'`
    if [ "$STATE" != "discharging" ]; then
        RESULT=`echo $CHARGE|gdbar -w $GDBW -h $GDBH -max $MAX`
        BAR=`echo $RESULT|awk '{ print $2 }'`
        PERCENT=`echo $RESULT|awk '{ print $1 }'`
        ICO="^i($ICONPATH/ac_01.xbm)"
    else
        RESULT=`echo $CHARGE|gdbar -w $GDBW -h $GDBH -max $MAX`
        BAR=`echo $RESULT|awk '{ print $2 }'`
        PERCENT=`echo $RESULT|awk '{ print $1 }'`
        NUM=`echo $PERCENT|sed s/\%//`
        if [ "$NUM" -gt "50" ]; then
            ICO="^i($ICONPATH/bat_full_01.xbm)"
            BATTERY_CRITICAL=`ls /tmp|grep battery_critical`
            if [ "$BATTERY_CRITICAL" != "" ]; then
                rm /tmp/battery_critical
            fi
        elif [ "$NUM" -gt "20" ]; then
            ICO="^i($ICONPATH/bat_low_01.xbm)"
            BATTERY_CRITICAL=`ls /tmp|grep battery_critical`
            if [ "$BATTERY_CRITICAL" != "" ]; then
                rm /tmp/battery_critical
            fi
        else
            ICO="^i($ICONPATH/bat_empty_01.xbm)"
            BATTERY_CRITICAL=`ls /tmp|grep battery_critical`
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
    MAX=`free -m|grep Mem|awk '{ print $2 }'`
    USE=`free -m|grep Mem|awk '{ print $3 }'`
    BAR=`echo $USE|gdbar -w $GDBW -h $GDBH -max $MAX|awk '{ print $1 }'`
    VICO="^i($ICONPATH/mem.xbm)"
    if [ `echo $BAR|cut -d '%' -f 1` -gt 90 ]; then
        COLOR="$ERRORCOLOR"
    fi
    echo "$COLOR$VICO $BAR$CLEARCOLOR"
}

myCPU(){
    ICO="^i($ICONPATH/cpu.xbm)"
    CPU=`gcpubar -c 2 |awk '{ print $2 }'`
    CPU=`echo $CPU|awk '{ print $2 }'`
    if [ `echo $CPU|cut -d '%' -f 1` -gt 90 ]; then
        COLOR="$ERRORCOLOR"
    fi
    echo "$COLOR$ICO $CPU$CLEARCOLOR"
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
    MAX=`sensors|grep temp1|awk '{ print $5 }'|cut -d '.' -f 1|sed s/+//g`
    TMP=`sensors|grep temp1|awk '{ print $2 }'|cut -d '.' -f 1|sed s/+//g`
    BAR=`echo $TMP|gdbar -w $GDBW -h $GDBH -max $MAX|awk '{ print $1 }'`
    ICO="^i($ICONPATH/temp.xbm)"
    COLOR="$COOLTEMPCOLOR"
    if [ `echo $BAR|sed s/\%//` -gt 90 ]; then
        notify-send "Temperature Critical" "Cool this bitch down."
        COLOR="$HOTTEMPCOLOR"
    fi
    echo "$COLOR$ICO $TMP°C$CLEARCOLOR"
}
while true ; do
    dt=`date +"%I:%M %a, %x"`
    echo "$(myDisks)$SEP$(myCPU)$SEP$(myMem)$SEP$(myVol)$SEP$(myTemp)$SEP$(myBat)$SEP$dt"
    sleep 1
done | dzen2 -h '16' -ta r -fg $FG -bg $BG -fn $FONT 


