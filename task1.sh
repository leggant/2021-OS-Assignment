#!/bin/bash

chmod 700 task1.sh
# set -x will force the output of debugger
set -x

#run a loop
for i in {1..10} ;do
    echo $i
done
set +x
for i in {a..z} ;do
    echo $i
done

#echo text 
echo "this is a test script"

DATE=$(date)
echo $DATE

#git fetch to get the data

git clone https://github.com/leggant/2021-OS-Assignment.git
cd 2021-OS-Assignment
git checkout automated-io
git status
pwd
# Check If Users File Exists
FILE=Users.csv
if [ -f "$FILE" ]; then
    echo -e "$FILE exists.\n\n" 
    cat $FILE
else 
    echo "$FILE does not exist."
fi

# Make make intermediary directories
#mkdir -p parent/child/grandchild

#output results to a text file.
#bash TutorialSeries/chapter1.sh 2> debug.txt