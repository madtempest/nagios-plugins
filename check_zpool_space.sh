#!/bin/sh
# Getting parameters:
while getopts "p:w:c:" OPT; do
    case $OPT in
        "p") pool=$OPTARG;;
        "w") warning=$OPTARG;;
        "c") critical=$OPTARG;;
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


pool_consumed="$(zpool list | awk -v awk_row=$row 'NR==awk_row { print $7}' | sed "s/%//")"
pool_free="$(( 100 - $pool_consumed ))"

if [ $pool_free -le $critical ]; then
        echo "CRITICAL - zpool $pool has used $pool_consumed% space.| $pool usage=$pool_consumed%"
		exit 2
elif [ $pool_free -le $warning ]; then
        echo "WARNING - zpool $pool has used $pool_consumed% space.| $pool usage=$pool_consumed%"
		exit 1
else 
        echo "OK - zpool $pool has used $pool_consumed% space.| $pool usage=$pool_consumed%"
		exit 0
fi