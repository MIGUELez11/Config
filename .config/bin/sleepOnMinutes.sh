#!/bin/sh

sleepTime=$(echo "scale=2;$1 * 60"|bc)

echo "sleeping in $1 minutes ($sleepTime s)"

sleep $sleepTime

pmset displaysleepnow
