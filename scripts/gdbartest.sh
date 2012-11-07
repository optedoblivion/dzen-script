#!/bin/sh
 
GDBAR=gdbar
 
echo -n "^fg(khaki)gdbar styles:^fg()   "
echo -n "default:  " $(echo 33 | $GDBAR -fg '#aecf96' -bg '#494b4f' -nonl)
echo -n "  segmented:  " $(echo 33 | $GDBAR -fg '#aecf96' -bg '#494b4f' -ss 1 -sw 4 -nonl)
echo -n "  outlined: " $(echo 33 | $GDBAR -fg '#aecf96' -bg '#494b4f' -s o -nonl)
echo -n "  vertical:" $(echo 35 | $GDBAR -h 30 -ss 0 -sw 8 -sh 2 -s v -fg red -bg grey40)
echo -n "  segmented:" $(echo 75 | $GDBAR -h 30 -sw 18 -sh 4 -ss 1 -s v -fg '#aecf96' -bg '#494b4f')
echo -n "  pie:" $(echo 70 | $GDBAR -s p -w 26 -fg grey40 -bg '#aecf96')
echo
| dzen2
