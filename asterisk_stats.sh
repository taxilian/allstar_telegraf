#!/bin/bash
# Allstar get stats script by Kyle Yoksh, K0KN
# March 2013
#
# This script is used to read stats from Asterisk for use in other 
# external scripts. 
#

if [ "$1" == "" ] ; then
echo "Usage = stats [your node#]"; exit
fi

tempfile=/dev/shm/xstats.$1
tempfile2=/dev/shm/xvars.$1

asterisk -rx "rpt stats $1" > $tempfile
asterisk -rx "rpt showvars $1" > $tempfile2

parse() {
   VAL=$(grep "$1" $tempfile | sed "s/^[^:]*://")
   echo $VAL
}
parse_bool() {
   VAL=$(parse $1)
   if [[ $VAL == *"ENABLED"* ]]; then
       echo 1
   else
       echo 0
   fi  
}
parse_time() {
   VAL=$(parse "$1")
   HOURS=$(echo ${VAL} | cut -d":" -f1)
   MINUTES=$(echo ${VAL} | cut -d":" -f2)
   SECS=$(echo ${VAL} | cut -d":" -f3)
   OUT=$(awk "BEGIN {print $HOURS*60*60 + $MINUTES*60 + $SECS; exit}")
#   echo Hours: ${HOURS}
#   echo Minutes: ${MINUTES}
#   echo Seconds: ${SECS}
   echo $OUT
}

SYSTEM=$(parse_bool 'System')
INCOMING=$(parse_bool 'Incoming connections')
TIMEOUTS=$(parse 'Time outs since system initialization')
KERCHUNKS=$(parse 'Kerchunks today')
KERCHUNKSTOTAL=$(parse 'Kerchunks since')
KEYUPSTODAY=$(parse 'Keyups today')
KEYUPSTOTAL=$(parse 'Keyups since system initialization')
DTMF_COMMANDS=$(parse 'DTMF commands today')
DTMF_TOTAL=$(parse 'DTMF commands today')
TXTIME_TODAY=$(parse_time 'TX time today')
TXTIME_TOTAL=$(parse_time 'TX time since system initialization')
UPTIME=$(parse_time 'Uptime' $tempfile)

echo {\"system_enabled\": ${SYSTEM},
echo \"incoming_connections\": ${INCOMING},
echo \"timeouts\": ${TIMEOUTS},
echo \"kerchunksToday\": ${KERCHUNKS},
echo \"kerchunksTotal\": ${KERCHUNKSTOTAL},
echo \"keyupsToday\": ${KEYUPSTODAY},
echo \"keyupsTotal\": ${KEYUPSTOTAL},
echo \"dmtfCmdsToday\": ${DTMF_COMMANDS},
echo \"dmtfCmdsTotal\": ${DTMF_TOTAL},
echo \"txTimeToday\": ${TXTIME_TODAY},
echo \"txTimeTotal\": ${TXTIME_TOTAL},
echo \"uptime\": ${UPTIME}}
