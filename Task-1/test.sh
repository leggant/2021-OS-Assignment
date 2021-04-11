#!/bin/bash
cat /etc/shells
which bash >> test.txt
echo "Hi Yogi And Bella" >> test.txt

# Run with this line only will take input from command line and save
#cat > test.txt # CTRL D to exit and save

: '
Multiline Comments'

cat << outputComments
this is hello create text
this is hello create text
this is hello create text
and another
outputComments