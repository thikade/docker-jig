# convert all JTL files into human readable timestamps
#!/bin/bash


EXECDIR=$(dirname $0)
cd $EXECDIR

DIR=${1:-.}
echo "searching in dir $DIR/ for *csv"

ALLFILES=$(ls  ${DIR}/*errorLog.csv ${DIR}/*jtl)
for F in $ALLFILES; do
   [ -f "${F}.hr.csv" ] && echo " - already converted: $F" && continue
   echo "converting: $F"
   python humanTimestamp.py $F
done

cd - > /dev/null
