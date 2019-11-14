#!/bin/bash

env| grep JMETER

echo "-------------------------------"
echo "new JMETER HEAP=$HEAP"
echo "-------------------------------"

export PATH=$PATH:${JMETER_BIN}
echo PATH=$PATH
jmeter -n -t test/${JMETER_TEST}
