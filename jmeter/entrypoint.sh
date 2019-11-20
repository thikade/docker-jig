#!/bin/sh

export PATH=$PATH:${JMETER_BIN}

env | grep JMETER

echo "-------------------------------"
echo "new JMETER HEAP=$HEAP"
echo "-------------------------------"

if [ -f "/data/${JMETER_PLAN}" ]; then
  echo "running jmx file:  /data/${JMETER_PLAN}"
  echo "-------------------------------"

  jmeter -n -t /data/${JMETER_PLAN}  -l /data/results_${JMETER_PLAN}_$(date +%Y%m%d-%H.%M.%S).jtl
else
  echo "no test plan found to run! (tried: \"/data/${JMETER_PLAN}\""
fi

[ "$1" = "tail" ] && tail -F /jmeter/jmeter.log
