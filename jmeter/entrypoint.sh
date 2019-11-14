#!/bin/bash

export PATH=$PATH:${JMETER_BIN}

env| grep JMETER

echo "-------------------------------"
echo "new JMETER HEAP=$HEAP"
echo "-------------------------------"
echo "running jmx file:  test/${JMETER_TEST}"
echo "-------------------------------"

jmeter -n -t test/${JMETER_TEST}
