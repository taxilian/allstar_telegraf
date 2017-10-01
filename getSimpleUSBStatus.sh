
SCRIPTNAME=${0%/*}/$1

asterisk -rx "susb active $2"
CURSTATS=$(${SCRIPTNAME}.exp | grep -A3 "^REAL" | tail -n 1)

parse() {
    VAL=$(echo $CURSTATS | cut -d'|' -f$1)
    if [[ $VAL == *"KEYED"* ]]; then
        echo 1
    else 
        echo 0
    fi
}

COS_COMPOSITE=$(parse 1)
COS_INPUT=$(parse 2)
COS_TEST=$(parse 3)
CTCSS_INPUT=$(parse 4)
CTCSS_OVERRIDE=$(parse 5)
PTT=$(parse 6)

echo {
echo \"cosComposite\": ${COS_COMPOSITE},
echo \"cosInput\": ${COS_INPUT},
echo \"cosTest\": ${COS_TEST},
echo \"ctcssInput\": ${CTCSS_INPUT},
echo \"ctcssOverride\": ${CTCSS_OVERRIDE},
echo \"ptt\": ${PTT},
echo }
