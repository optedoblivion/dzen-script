## Fan module ##

## Colors

function run() {
    MIN=$(sensors | grep Exhaust | awk '{ print $7 }')
    MAX=$(sensors | grep Exhaust | awk '{ print $11 }')
    RPM=$(sensors | grep Exhaust | awk '{ print $3 }')
    echo "" 
}
