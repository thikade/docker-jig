#!/bin/sh

export PATH=$PATH:${JMETER_BIN}

env| grep JMETER

echo "-------------------------------"
echo "new JMETER HEAP=$HEAP"
echo "-------------------------------"
echo "running jmx file:  test/${JMETER_TEST}"
echo "-------------------------------"

jmeter -n -t test/${JMETER_TEST}  -l results_${JMETER_TEST}_$(date +%Y%m%d-%H.%M.%S).jtl

tail -f /jmeter/jmeter.log
