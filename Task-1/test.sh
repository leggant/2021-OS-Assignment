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
# -a == &&
age=110
if [ $age -gt 18 ] && [ $age -lt 50 ]
# if [[ $age -gt 18 && $age -lt 50 ]] works and 
# if [ $age -gt 18 -a $age -lt 50 ] also works
then
    echo "Age is ok to enter"
elif [ $age -eq 100 ] || [ $age -gt 100 ]
# if [[ $age -eq 100 || $age -gt 100 ]] works and 
# if [ $age -eq 100 -o $age -gt 100 ] also works
then
    echo "Wow You Are Old!"
else
    echo "Nope!"
fi
## case statements
car=$1
case $car in
    "BMW" )
        echo "It's a BMW" ;;
    "Merc" )
        echo "It's a Mercedes" ;;
    "Toyota" )
        echo "Its a Toyota" ;;
    "Honda" )
        echo "It's a Honda" ;;
    * )
        echo "Unknown" ;;
esac

## Loops -le less than or equal
x=1
while [ $x -le 10 ]
do
    # outputs 1-10
    echo "$x"
    x=$(( x+1 ))
done
x=1
until [ $x -ge 10 ]
do
    # outputs 1-10
    # loops until true
    echo "$x"
    x=$(( x+1 ))
done

# for loops
# for i in 1 2 3 4 5
#for i in {0..20}
for i in {0..20..5} # 3rd int adds an increment
do  
    echo $i
done

