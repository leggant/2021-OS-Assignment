#!/bin/bash

currentPath=$(pwd)
currentFileName=$(echo "${currentPath##*/}")
userInputDirectory=""
exitapp() {
    clear
    echo -e "\n\nExiting the Program....."
    exit 1
}
askUserForDirectory() {
    read -p "Enter the full path to the directory you would like to compress and transfer or press enter if you wish to use the current path: " path
    if [ ${#path} -eq 0 ]; then
        userInputDirectory=$currentPath;
        checkDirectoryExists $userInputDirectory;
    else 
        userInputDirectory=$path
        checkDirectoryExists $userInputDirectory;
    fi
}
checkDirectoryExists() {
   [[ -d $1 ]] && echo "$1 directory exists!" && userInputDirectory=$1 && return 0;
   [[ ! -d $1 ]] && echo "$1 directory not exists!" && return 1; 
}
getUserInput() {
    askUserForDirectory
    echo -e "Current file is $currentFileName\nCurrent Dir is $currentPath"
    echo $?
}
StartScript() {
echo -e "\n#####################################\n###### Directory Backup Script ######\n#####################################\n"
echo -e "This Script Will Compress a Directory of Your Choosing and Backup This File To A Remote Server\n"
read -p "Do You Wish To Continue? " continue
counter=1
until [ $counter -eq 3 ]
do
if [[ $continue = "yes" || $continue = "y" || $continue = "YES" || $continue = "Y" ]]; then
    clear
    return 0
elif [[ $continue = "no" || $continue = "n" || $continue = "NO" || $continue = "N" ]]; then
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
    getUserInput
elif [ $ok -eq 1 ]; then
    echo "exit program"
fi