#!/bin/bash

export PATH=$PATH:${JMETER_BIN}

env | grep JMETER

echo "-------------------------------"
echo "new JMETER HEAP=$HEAP"
echo "-------------------------------"

# Run only if 'notest' is NOT specified nywhere in arglist
ARGS=$*
echo "ARGS = $ARGS"

if [ ! -z "${ARGS/*notest*/}"] ; then
    if [ -f "/data/${JMETER_PLAN}" ]; then
      echo "running jmx file:  /data/${JMETER_PLAN}"
      echo "-------------------------------"

      jmeter -n -t /data/${JMETER_PLAN}  -l /data/results_${JMETER_PLAN}_$(date +%Y%m%d-%H.%M.%S).jtl
    else
      echo "no test plan found to run! (tried: \"/data/${JMETER_PLAN}\""
    fi
fi

[ -z "${ARGS/*tail*/}" ] && tail -F /jmeter/jmeter.log 2>/dev/null
