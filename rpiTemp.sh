#!/usr/bin/env bash

CURTEMP=$(/opt/vc/bin/vcgencmd measure_temp | tr "=" "\n" | tail -n 1 | tr "'" "\n" | head -n 1)

echo {\"temperature\": $CURTEMP}
