#!/bin/sh
# Getting parameters:
while getopts "p:" OPT; do
    case $OPT in
        "p") pool=$OPTARG;;
    esac
done

iterate="$(zpool list | wc -l | tr -d ' ')"
iterate="$(( $iterate + 1 ))"

i=2

while
        : ${start=$i}
        poolname="$(zpool list | awk -v awk_i=$i  'NR==awk_i { print $1 }')" 
                if [ $poolname = $pool ]; then
                        row=$i
                        break
                fi
        i="$(( $i+1 ))"
        [ "$i" -lt $iterate ]
do :;
done


pool_health="$(zpool list | awk -v awk_row=$row 'NR==awk_row { print $9}')"

if [ $pool_health = "OFFLINE" ]; then
        echo "CRITICAL - zpool $pool is $pool_health."
		exit 2
elif [ $pool_health = "DEGRADED" ]; then
        echo "WARNING - zpool $pool is in a $pool_health state."
		exit 2
else 
        echo "OK - zpool $pool is $pool_health."
		exit 0
fi