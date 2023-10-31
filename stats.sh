#!/bin/sh

# Script for gathering statistics about existing LASRCOP session recordings

OUTPUTFILE="lasrcop_stats.csv"
STARTTS=1692622800				# Monday, August 21, 2023 8:00:00 AM GMT-05:00
LASRCOPDIR=/var/sessions
INC=$((60 * 60 * 24))		# 1 day

echo "timestamp,usercount,disksize,numsessions" > $OUTPUTFILE
echo "timestamp | usercount | disksize | numsessions"
TS=$STARTTS
while [ $TS -le $(date +%s) ]; do

	TIMESTR=$(date -d @$TS | cut -d' ' -f2,3)
	USER_COUNT=$(find $LASRCOPDIR -type f -not -newerct "$TIMESTR" -name \*.cast | cut -d'/' -f4 | uniq | wc -l)
	DISK_SIZE=$( (find $LASRCOPDIR -type f -not -newerct "$TIMESTR" | xargs stat "--printf=%s+"; echo 0) | bc)
	NUM_SESSIONS=$(find $LASRCOPDIR -type f -not -newerct "$TIMESTR" -name \*.cast | wc -l)

	echo $TIMESTR '|' $USER_COUNT '|' $DISK_SIZE '|' $NUM_SESSIONS
	echo $TIMESTR,$USER_COUNT,$DISK_SIZE,$NUM_SESSIONS >> $OUTPUTFILE

	TS=$(($TS + $INC))

done
