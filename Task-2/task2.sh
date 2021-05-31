#!/bin/bash

currentPath=$(pwd)
currentFileName=$(echo "${currentPath##*/}")
userInputDirectory=""
outputFileName="default"
log="log.txt"

logUser() {
    message=$1;
    echo -e "\n>>>> $message";
    echo -e "\n>>>> $message";
}

logError() {
    message=$1;
    echo -e "\n>>>>ERROR<<<< $message";
    echo -e "\n>>>>ERROR<<<< $message";
}

# Destination Ip 
getDestinationIP() {
    echo "Get Destination"
}

# file name
getZipFileName() {
    echo "Zip File Name?"
}

# destination folder
getDestinationDirectory() {
    echo "Get Dest Directory"
}

# port number
getPortNumber() {
    echo "Default is 22"
}

# zip the file
createZip() {
    tar -czvf $outputFileName.tar.gz $userInputDirectory 2>>$log;
}

# send to remote
sendToRemoteHost() {
    echo "Send Zip To Remote"
}

exitapp() {
    clear
    echo -e "\n\nExiting the Program....."
    exit 1
}

askUserForDirectory() {
    read -p "Enter the full path to the directory you would like to compress and transfer or press enter if you wish to use the current path: " path
    ok=1
    counter=1;
    until [ $counter -eq 3 ]
    do
        if [ ${#path} -eq 0 ]; then
            userInputDirectory=$currentPath;
            checkDirectoryExists $userInputDirectory;
            ok=$?
        else 
            userInputDirectory=$path
            checkDirectoryExists $userInputDirectory;
            ok=$?
        fi
        if [ $ok -eq 0 ]; then
            tar -czvf $outputFileName.tar.gz $userInputDirectory 2>>$log;
        fi
        ((counter++))
        if [ $counter -eq 3 ]; then
            echo "$counter attempts failed"
            echo "Please Try Again Later"
            exit 1
        fi
    done
}
sendToRemote() {
    scp -P 22 default.tar.gz #username@ipaddress : inputfiledirectoryonremote
}

checkRemoteOnline() {
    echo "check remote ip wget?"
}

checkDirectoryExists() {
   [[ -d $1 ]] && echo "$1 directory exists!" && userInputDirectory=$1 && return 0;
   [[ ! -d $1 ]] && echo "$1 directory not exists!" && return 1; 
}
getUserInput() {
    askUserForDirectory
    echo -e "Current file is $currentFileName\nCurrent Dir is $currentPath"
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
