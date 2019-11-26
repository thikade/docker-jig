#!/bin/bash

export PATH=$PATH:${JMETER_BIN}

env | sort | grep JMETER

echo "-------------------------------"
echo "new JMETER HEAP=$HEAP"
echo "-------------------------------"

echo ""
echo "startup script name is: $0"
echo "args are              : $*"
echo "-------------------------------"

TS_FORMAT=+%Y-%m-%d-%H.%M.%S
TS=$(date $TS_FORMAT)
PREFIX=${JMETER_PLAN}_${TS}
JM_LOG=$(dirname $JMETER_PLAN)/jmeter.log
REPORT_DIR=${PREFIX}_report
SAMPLES_LOG=${PREFIX}_samples.jtl

# if script is called using "entrypoint.sh", just tail the JMeter logs!
if [ "$(basename $0)" = "entrypoint.sh" ]
then
  # container startup will tail log forever
  echo "$TS: tailing jmeter log(s): \"$JM_LOG\" ..."
  echo "-------------------------------"
  tail -F $JM_LOG  2>/dev/null
fi

# script is called using "run" ...

if [ "$JMETER_ROLE" = "SLAVE" ]
then
  # this is a slave container
  echo "starting the JMeter SLAVE server process ..."
  jmeter-server &
  sleep 3
  # slaves use their own log file
  tail -F /jmeter/jmeter-server.log 2>/dev/null

elif [ "$JMETER_ROLE" = "MASTER" ]
then
  if [ -f "$JMETER_PLAN" ]
  then
    # test -d $REPORT_DIR || mkdir $REPORT_DIR
    echo -e "\n\n"
    echo "=> user.props: number of threads:  $(grep threads=  /data/user.properties)"
    echo "=> user.props: duration         :  $(grep duration= /data/user.properties)"
    echo "=> user.props: rampUp           :  $(grep rampUp=   /data/user.properties)"
    echo -e "\n\n"
    echo "$TS : starting the JMeter MASTER process ..."
    test -n "$DEBUG" && set -x
    jmeter -n -t ${JMETER_PLAN} -j ${JM_LOG} -l ${SAMPLES_LOG} -e -o $REPORT_DIR -G/data/user.properties ${JMETER_REMOTE_SERVERS} $*
    set +x
    echo "$(date $TS_FORMAT) : finished JMeter run."
  else
    echo "ERROR: unable to read JMeter plan: \"$JMETER_PLAN\" !"
  fi
else
  echo "FATAL ERROR: Env var 'JMETER_ROLE' needs to be either 'MASTER' or 'SLAVE' !"
  echo "Aborting..."
fi
