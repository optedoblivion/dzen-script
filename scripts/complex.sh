#!/bin/sh
#
# (c) 2008 Robert Manea
#
# sonata osd like display for dzen
#
 
# artist font
A_FG='#5A863A'
A_FNT='-*-*-*-*-*-*-22-*-*-*-*-*-*-*'
A_FNH=22
 
# song font
S_FG='#BDBABD'
S_FNT='-*-*-*-*-*-*-13-*-*-*-*-*-*-*'
S_FNH=13
 
# gauge & time
T_FNH=9
RCT_H=9
 
while :; do
ARTIST=$(mocp -i | sed -ne 's/^Artist: \(.*\)$/\1/p')
CURSNG=$(mocp -i | sed -ne 's/^SongTitle: \(.*\)$/\1/p')
 
CURTIME=$(mocp -i | sed -ne 's/^CurrentTime: \(.*\)$/\1/p')
TOTTIME=$(mocp -i | sed -ne 's/^TotalTime: \(.*\)$/\1/p')
 
CURMIN=$(echo $CURTIME | sed -ne 's/\([0-9]*\):\([0-9]*\)/\1\*60+\2/p' | bc)
TOTMIN=$(echo $TOTTIME | sed -ne 's/\([0-9]*\):\([0-9]*\)/\1\*60+\2/p' | bc)
 
 
A_TW=`textwidth "${A_FNT}" "${ARTIST:-No artist}"`
S_TW=`textwidth "${S_FNT}" "${CURSNG:-No song}"`
 
GAUGE=$(echo $CURMIN $TOTMIN | gdbar -fg '#BDBA8C' -bg '#425142' -h $RCT_H -w 200 -nonl)
 
# here we actually build the interface
echo "^ib(1)^fg(#425142)^r(10x90)^fg()^fn(dfnt2)^pa(2;5)D^pa(2)^p(;9)Z^pa(2)^p(;9)E^pa(2)^p(;9)N ^p()^i(cover.xpm)^pa(;0)^fn(dfnt0)^fg(${A_FG})${ARTIST:-Noartist}^p(-${A_TW};+`expr $A_FNH + 2`)^fn(dfnt1)^fg(${S_FG})${CURSNG:-No song}^p(-${S_TW};+`expr S_FNH + 3`)${GAUGE} ^fn(dfnt2)^fg(#425142)${CURTIME}/${TOTTIME}"
 
 
sleep 1
done | dzen2 -h 62 -w 400 -p -y 90 -x 400 -bg gray10 -ta l \
-fn-preload '-*-*-*-*-*-*-22-*-*-*-*-*-*-*,-*-*-*-*-*-*-13-*-*-*-*-*-*-*,-*-*-*-*-*-*-9-*-*-*-*-*-*-*'
