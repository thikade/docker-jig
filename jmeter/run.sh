#!/bin/bash

export PATH=$PATH:${JMETER_BIN}

env | grep JMETER

echo "-------------------------------"
echo "new JMETER HEAP=$HEAP"
echo "-------------------------------"

echo ""
echo "startup script name is: $0"
echo "args are              : $*"
echo "-------------------------------"

# script is called using "entrypoint.sh" ...
if [ "$(basename $0)" = "entrypoint.sh" ]
then
  # container startup will tail log forever
  echo "tailing jmeter log ..."
  echo "-------------------------------"
  while true; do
    tail -F /jmeter/jmeter.log 2>/dev/null
    echo "tailing jmeter log ..."
    sleep 5
  done
fi


# script is called using "run" ...

if [ "$JMETER_ROLE" = "SLAVE" ]
then
  # this is a slave container
  echo "starting the JMeter SLAVE server process ..."
  jmeter-server &
  tail -F /jmeter/jmeter-server.log

elif [ "$JMETER_ROLE" = "MASTER" ]
then
  TS=$(date +%Y%m%d-%H.%M.%S)
  echo "$TS : starting the JMeter MASTER process ..."
  JMETER_TESTPLAN=${1:-$JMETER_PLAN}
  # BASE_NAME=$(basename ${JMETER_TESTPLAN})
  mkdir /data/$TS
  jmeter -n -t ${JMETER_TESTPLAN}  -l ${JMETER_TESTPLAN}.results-$(date +%Y%m%d-%H.%M.%S).jtl -e -o /data/$TS  $*
  echo "$TS : finished."
else
  echo "FATAL ERROR: Env var 'JMETER_ROLE' needs to be either 'MASTER' or 'SLAVE' !"
  echo "Aborting..."
fi


#
# # Run only if 'notest' is NOT specified nywhere in arglist
# ARGS="$* -"
# echo "ARGS = \"$ARGS\""
#
# if [ ! -z "${ARGS/*notest*/}" ] ; then
#     if [ -f "/data/${JMETER_TESTPLAN}" ]; then
#       echo "running jmx file:  /data/${JMETER_TESTPLAN}"
#       echo "-------------------------------"
#
#       jmeter -n -t /data/${JMETER_TESTPLAN}  -l /data/results_${JMETER_TESTPLAN}_$(date +%Y%m%d-%H.%M.%S).jtl
#     else
#       echo "no test plan found to run! (tried: \"/data/${JMETER_TESTPLAN}\""
#     fi
# else
#     echo "skipping Jmeter test run!"
# fi
