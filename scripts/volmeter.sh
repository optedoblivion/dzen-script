#!/bin/bash
# little dzen-thingy to control your volume
# you need amixer (or aumix) and gdbar
# (c) 2007 Tom Rauchenwald and Jochen Schweizer
 
BG='#000'     # dzen backgrounad
FG='#888'     # dzen foreground
W=150         # width of the dzen bar
GW=50         #  width of the volume gauge
GFG='#a8a3f5' # color of the gauge
GH=7          # height of the gauge
GBG='#333'    # color of gauge background
X=0         # x position
Y=0         # y position
 
# Caption of the gauge
# in this case it displays the volume icon shipped with dzen
CAPTION="^i(/home/sec/share/images/volume.xbm) "
# Font to use
FN='-*-clean-*-*-*-*-10-*-*-*-*-*-*-*'
 
# command to increase the volume
CI="amixer -c0 sset PCM 5dB+ >/dev/null"
#CI="aumix -v +5"
# command to decrease the volume
CD="amixer -c0 sset PCM 5dB- >/dev/null"
#CD="aumix -v -5
 
# command to pipe into gdbar to display the gauge
# should print out 2 space-seperated values, the first is the current
# volume, the second the maximum volume
MAX=`amixer -c0 get PCM | awk '/^  Limits/ { print $5 }'`
#MAX=100
CV="amixer -c0 get PCM | awk '/^  Front Left/ { print \$4 \" \" $MAX }'"
#CV="aumix -q | line | cut -d \" \" -f 3"
 
while true; do
    echo -n $CAPTION
    eval "$CV" | gdbar -h $GH -w $GW -fg $GFG -bg $GBG
    sleep 1;
done | dzen2 -ta c -fg $FG -bg $BG -e "button3=exit;button4=exec:$CI;button5=exec:$CD" -fn $FN
