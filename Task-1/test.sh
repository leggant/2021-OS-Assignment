#!/bin/bash
cat /etc/shells
which bash >> test.txt
echo "Hi Yogi And Bella" >> test.txt

# Run with this line only will take input from command line and save
#cat > test.txt # CTRL D to exit and save

: '
Multiline Comments'

cat << outputComments
Conditional
Statements
outputComments

count=4
if [ $count -eq 9 ]
then
    echo "Count is equal to $count"
elif (( $count <= 5 ))
then
    echo "the condition is less than or eq to five"
else
    echo "Count is not equal to $count"
fi

: '
-ne = not equal || -gt = greater than 
or (( $count > 9 )) replace [ ] wrapper with (( ))
or (( $count < 9 ))
'

# And Operator

age=110
if [ $age -gt 18 ] && [ $age -lt 50 ]
then
    echo "Age is ok to enter"
elif [ $age -eq 100 ] || [ $age -gt 100 ]
then
    echo "Wow You Are Old!"
else
    echo "Nope!"
fi