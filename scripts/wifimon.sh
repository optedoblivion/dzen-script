#!/bin/bash
#
# (c) 2007, by Robert Manea
# (c) 2007, Christian Dietrich
 
# icons
ICONPATH=$HOME/.dzen
# network interface
INTERFACE=eth0
WIRELESS=yes
# update every x seconds
SLEEP=1
FG='#ccc'
BG='#222'
BBG='#333' # Bar Background
BFG=green  # Bar Foreground
X=774
Y=0
WIDTH=250
 
 
# Here we remember the previous rx/tx counts
RXB=`cat /sys/class/net/${INTERFACE}|>/statistics/rx_bytes`
TXB=`cat /sys/class/net/${INTERFACE}|>/statistics/tx_bytes`
 
LINES=2
if [ x"$WIRELESS" = x"yes" ]; then
  LINES=5
fi
 
while :; do
 
# get new rx/tx counts
  RXBN=`cat /sys/class/net/${INTERFACE}|>/statistics/rx_bytes`
  TXBN=`cat /sys/class/net/${INTERFACE}|>/statistics/tx_bytes`
 
# calculate the rates
# format the values to 4 digit fields
  RXR=$(printf "%4d\n" $(echo "($RXBN - $RXB) / 1024/${SLEEP}" | bc))
  TXR=$(printf "%4d\n" $(echo "($TXBN - $TXB) / 1024/${SLEEP}" | bc))
  OWN_IP=$(/sbin/ifconfig $INTERFACE | sed -ne '/inet addr/ s/.*addr:\([^ ]*\).*/\1/p')
  ROUTER=$(/sbin/route -n | awk '$1 ~ /0.0.0.0/ {print $2}')
 
  if [ x"$WIRELESS" = x"yes" ]; then
    SIGNAL=$( /sbin/iwconfig $INTERFACE | sed -ne '/Link Quality/ { s/.*Link Quality:\([0-9]*\)\/\([0-9]*\).*/\1/p}' )
    SIGNALMETER=`echo $SIGNAL | gdbar -h 15  -fg $BFG \
                -bg $BBG -nonl`
    WLAN_DETAILS=$(/sbin/iwconfig $INTERFACE | awk '
                   /^'$INTERFACE'/ {print gensub(":", ": ", 1, $4)}
      /Mode/ {print "Access Point: " $6}
      /Bit Rate/ {print "Bit Rate: " gensub(".*=(.*)", "\\1 MB/s", 1, $2)}')
  fi
 
 
# print out the rates with some nice formatting
  echo "^tw()${INTERFACE}: ^fg(white)${RXR}kB/s^fg(#80AA83)^p(3)\
  ^i(${ICONPATH}/arr_down.xbm)^fg(white)${TXR}kB/s^fg(orange3)\
  ^i(${ICONPATH}/arr_up.xbm)^fg() $SIGNALMETER
^cs()
IP: $OWN_IP
Router: $ROUTER
$WLAN_DETAILS"
 
# reset old rates
  RXB=$RXBN; TXB=$TXBN
 
  sleep $SLEEP
done | dzen2 -bg $BG -fg $FG -ta c -l $LINES -x $X \
       -y $Y -w $WIDTH -e 'entertitle=uncollapse;leavetitle=collapse'


