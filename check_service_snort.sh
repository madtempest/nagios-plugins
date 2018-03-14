#!/bin/sh

#Let's check if snort is even running as a daemon first
pfSsh.php playback svc status snort > /tmp/service_snort_status
service_status="$(awk 'NR==2{ print $4 }' /tmp/service_snort_status)"

if [ $service_status != "running." ]
then
	echo "CRITICAL - Snort is not running!"
	exit 2
else 

INTERFACE=
while getopts "i:" OPTION
do
        case $OPTION in
                i)
                        INTERFACE=$OPTARG
                        ;;
esac
done

if [ "$INTERFACE" = "re0" ]; then
        INTERFACE="$(find /var/run -iname "*snort_re0*" -type s)"
        int_name="re0"
fi



fi