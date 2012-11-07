#!/bin/zsh                                                                                          
#
# pseudo equalizer visualization for dzen2
 
 
# Customize
CHANNELS=8
HEIGHT=24
SS=2
SW=10
SH=1
P=1
PADY=8
PADX=20
SLEEP=.5
 
while :; do
    for i in {1..$CHANNELS}; do
        echo $((RANDOM%100)) | \
        gdbar -fg $(printf "#%x%x%x" $((RANDOM%255)) $((RANDOM%255)) $((RANDOM%255))) \
        -bg grey20 \
        -nonl -s v -h $HEIGHT -ss $SS -sw $SW -sh $SH
        echo -n "^p(${P})"
    done; echo
 
    sleep $SLEEP;
done | dzen2 -h $(( HEIGHT+PADY )) -w $(( (SW+P)*CHANNELS+PADX ))
