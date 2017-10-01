#!/bin/bash
# Allstar get status script by Richard Bateman
# March 2013
#

if [ "$1" == "" ] ; then
echo "Usage = stats [your node#]"; exit
fi

tempfile=/dev/shm/xstatus.$1

asterisk -rx "rpt showvars $1" > $tempfile

#cat $tempfile

parse() {
    VAR=$(grep "$1" $tempfile | sed "s/^[^=]*=//")
    echo $VAR
}

KEYED=$(parse 'RPT_TXKEYED')
ETXKEYED=$(parse 'RPT_ETXKEYED')
RXKEYED=$(parse 'RPT_RXKEYED')
NUMLINKS=$(parse 'RPT_NUMLINKS')
NUMALINKS=$(parse 'RPT_NUMALINKS')

echo {
echo \"txkeyed\": ${KEYED},
echo \"etxkeyed\": ${ETXKEYED},
echo \"rxkeyed\": ${RXKEYED},
echo \"numlinks\": ${NUMLINKS},
echo \"numalinks\": ${NUMALINKS}
echo }
