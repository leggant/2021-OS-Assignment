#!/bin/bash
set -x
for i in {1..10} ;do
    echo $i
done
set +x
for i in {a..z} ;do
    echo $i
done

echo this is a test script

# Make make intermediary directories
#mkdir -p parent/child/grandchild

#output results to a text file.
#bash TutorialSeries/chapter1.sh 2> debug.txt

# Check If Users File Exists

FILE=task_1/Users.csv
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "$FILE does not exist."
fi