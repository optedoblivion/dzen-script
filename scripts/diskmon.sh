#!/bin/sh
# Disk usage monitor using dzen
# needs gawk
# (c) Tom Rauchenwald
 
FN='-*-clean-*-*-*-*-10-*-*-*-*-*-*-*'
BG='#000000'  #dzen background
FG='#888888'  #dzen foreground
W=200         #bar width
X=1024        #x position
Y=768         #y position
GH=7          #gauge height
GW=50         #gauge width
GFG='#a8a3f7' #gauge color
GBG='#333'    #gauge background
 
gawk "
BEGIN {
    CMD=\"gdbar -w $GW -h $GH -fg '$GFG' -bg '$GBG'\"
    while(1) {
        i=1
        while ((\"df\" | getline ) > 0)
        { if (\$0 ~ /^\//) {
                print \$5 |& CMD
                CMD |& getline lin
                if (i == 1)
                    print \"^cs()\\n^tw()\", \$6, lin
                else
                    print \$6, lin, \"  \"
                i++
                close(CMD)
            }
        }
        close(\"df\")
        system(\"sleep 5\")
    }
}" | dzen2 -ta c -sa r -l 5 -w $W -tw $W -x $X -y $Y -fg $FG -bg $BG -fn $FN -e "button1=togglecollapse;button3=exit"
