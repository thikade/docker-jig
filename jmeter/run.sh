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
  if [ -f "$JMETER_PLAN" ]
  then
    echo "$TS : starting the JMeter MASTER process ..."
    test -d /data/$TS || mkdir /data/$TS
    jmeter -n -t ${JMETER_PLAN}  -l ${JMETER_PLAN}.results-$(date +%Y%m%d-%H.%M.%S).jtl -e -o /data/$TS  ${JMETER_REMOTE_SERVERS} $*
    echo "$TS : finished."
  else
    echo "ERROR: unable to read JMeter plan: \"$JMETER_PLAN\" !"
  fi
else
  echo "FATAL ERROR: Env var 'JMETER_ROLE' needs to be either 'MASTER' or 'SLAVE' !"
  echo "Aborting..."
fi
