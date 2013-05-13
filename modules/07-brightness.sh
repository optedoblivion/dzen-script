## Display module ##

## Colors

function run() {
    MAX=$(cat /sys/class/backlight/acpi_video0/max_brightness)
    BRIGHTNESS=$(cat /sys/class/backlight/acpi_video0/brightness)
    PERCENT=$(echo "scale=2; ($BRIGHTNESS/$MAX) * 100" | bc -q 2>/dev/null)
    PERCENT=$(echo "$PERCENT" | cut -d "." -f 1)
    echo "$PERCENT%"
}
