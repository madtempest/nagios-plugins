#!/bin/sh

usage()
{
cat << EOF
usage: $0 options

Nagios plugin to check the quota consumption of a ZFS dataset.

OPTIONS:
   -h           Show this message
   -d           Select a dataset to query

EOF
}

DATASET=
while getopts "hd:" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         d)
             DATASET=$OPTARG
             exit 1
             ;;
		?)
			usage
			exit
			;;
	esac
done

if [ -z "$DATASET" ];
then
	usage
fi

if [ ! -z "$DATASET" ]

zfs list -t filesystem -o name,used,refquota | grep acquisition























fi