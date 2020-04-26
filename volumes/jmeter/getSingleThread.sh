#!/bin/bash

# first, convert into human readable timestamps
bash humanTimestamps.sh

# thread name is jmeter-slave2-priv.2i.at:1099-jmeter-slave2-priv.2i.at_CTG-ThreadStarter 1-1
# GET THREAD REQUIRES
# 1)  A SLAVE NUMBER T
# 2)  Thread ID   X-Y

FILE=$1
SLAVENUM=$2
THREADID=$3


if [ -z "$FILE" -o ! -f "$FILE" ]; then
   cat << EOT

File "$FILE" is empty or cannot be read!

EOT
   exit 2
fi
if [ -z "$SLAVENUM" -o -z "$THREADID" ]; then
   cat << EOT

GET THREAD REQUIRES
1)  A SLAVE NUMBER T
2)  Thread ID   X-Y

EOT
   exit 1
fi

TID="jmeter-slave${SLAVENUM}-priv.2i.at:1099-jmeter-slave${SLAVENUM}-priv.2i.at_CTG-ThreadStarter ${THREADID},"
cat << EOT

extracting Thread with name: $TID

EOT

NEWFILE="${FILE}_S:${SLAVENUM}_T:${THREADID}.csv"
# keep 1st line
head -n1 $FILE >  $NEWFILE
grep "$TID" $FILE >>  $NEWFILE

column -s, -t $NEWFILE | less -#20 -SN

