#!/bin/bash

StartScript() {
echo -e "\n#####################################\n###### Directory Backup Script ######\n#####################################\n"
echo -e "This Script Will Compress a Directory of Your Choosing and Backup This File To A Remote Server\n"
read -p "Do You Wish To Continue? " continue
counter=1
until [ $counter -eq 3 ]
do
if [[ $continue = "yes" || $continue = "y" || $continue = "YES" || $continue = "Y" ]]; then
    echo "$continue ok"
    return 0
elif [[ $continue = "no" || $continue = "n" || $continue = "NO" || $continue = "N" ]]; then
    echo "$continue no"
    exitapp "Now Exiting the Program......"
else
    echo "Sorry I Dont Understand, Please Enter Yes Or No"
    read -p "Do You Wish To Continue? " continue
fi
((counter++))
if [ $counter -eq 3 ]; then
    echo "$counter attempts failed"
    echo "Please Try Again Later"
    exit 1
fi
done
}
StartScript
ok=$?
if [ $ok -eq 0 ]; then
    # ask for user inputs
elif [ $ok -eq 1 ]; then
    #exit program
fi