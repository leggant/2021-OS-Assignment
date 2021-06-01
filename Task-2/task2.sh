#!/bin/bash

currentPath=$(pwd)
currentFileName=$(echo "${currentPath##*/}")
userInputDirectory=""
outputFileName="default"
inputIP=""
port=22
log="log.txt"

# ---------------------------------------------------------------------------- #
#                          LOGGING AND ERROR HANDLING                          #
# ---------------------------------------------------------------------------- #

logUser() {
    message=$1;
    echo -e "\n>>>> $message";
    echo -e "\n>>>> $message">>$log;
}

logError() {
    message=$1;
    echo -e "\n>>>>ERROR<<<< $message";
    echo -e "\n>>>>ERROR<<<< $message">>$log;
}

exitapp() {
    clear
    logUser "Exiting the Program....."
    pause
    clear
    exit 1
}

pause() {
    sleep 3;
}

# ---------------------------------------------------------------------------- #
#      GET INPUT FROM USERS TO SELECT A FILE, OUTPUT FILE AND REMOTE HOST      #
# ---------------------------------------------------------------------------- #

# Destination Ip
getDestinationIP() {
    read -p "Enter the destination username and IP address: " ip
    inputIP=$ip;
    echo $inputIP;
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
    echo "The Default Port For SSH is 22."
    read "Press Enter If You Wish To Use This Port, or Enter A New Port Number Here: " newport
    if [ ]; then
        port=$newport;
    fi
}

# zip the file
createZip() {
    tar -czvf $outputFileName.tar.gz $userInputDirectory 2>>$log;
}

# send to remote
sendToRemoteHost() {
    echo "Send Zip To Remote"
}


askUserForDirectory() {
    read -p "Enter the full path to the directory you would like to compress and transfer or press enter if you wish to use the current path: " path
    ok=1
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
        #Delete previous file if it exists to prevent a duplicate file getting created.
        if [ -f $outputFileName ]; then
            rm $outputFileName.tar.gz;
        fi 
        tar -czvf $outputFileName.tar.gz $userInputDirectory 2>>$log;
    fi
}
sendToRemote() {
    scp -P 22 default.tar.gz #username@ipaddress : inputfiledirectoryonremote
}

checkRemoteOnline() {
    echo "check remote ip wget?"
}

checkDirectoryExists() {
    [[ -d $1 ]] && logUser "$1 directory exists!" && userInputDirectory=$1 && return 0;
    [[ ! -d $1 ]] && logUser ">>> Error >>> $1 directory Does Not Exist!." && return 1;
}

getUserInput() {
    counter=1;
    error=0;
    until [[ $counter -eq 3 || $error -eq 1 ]]
    do
        askUserForDirectory
        echo -e "Current file is $currentFileName\nCurrent Dir is $currentPath"
        echo "Sorry I Dont Understand, Please Enter Yes Or No"
        read -p "Do You Wish To Continue? " answer
        if [[ $answer = "yes" || $answer = "y" || $answer = "YES" || $answer = "Y" ]]; then
            clear
            return 0
            elif [[ $answer = "no" || $answer = "n" || $answer = "NO" || $answer = "N" ]]; then
            exitapp "Now Exiting the Program......";
            elif [ $counter -eq 3 ]; then
            logError "$counter attempts failed. Please Try Again Later"
        fi
        ((counter++))
    done
}

checkInput() {
    if [[ $answer = "yes" || $answer = "y" || $answer = "YES" || $answer = "Y" ]]; then
        clear
        return 0
    elif [[ $answer = "no" || $answer = "n" || $answer = "NO" || $answer = "N" ]]; then
        exitapp "Now Exiting the Program......";
    elif [ $counter -eq 3 ]; then
        logError ">>>>$counter attempts failed. Please Try Again Later."
    fi
}

StartScript() {
    clear
    echo "#------------------------------------------------------------------------------#"
    echo "#-----------------------AUTOMATED DIRECTORY BACKUP SCRIPT----------------------#"
    echo "#------------------------------------------------------------------------------#"
    echo -e "This Script Will Compress a Directory of Your Choosing and Backup This File To A Remote Server\n"
    read -p "Do You Wish To Continue? " answer
    counter=1
    until [ $counter -eq 3 ]
    do
        if [[ $answer = "yes" || $answer = "y" || $answer = "YES" || $answer = "Y" ]]; then
            clear
            return 0
            elif [[ $answer = "no" || $answer = "n" || $answer = "NO" || $answer = "N" ]]; then
            exitapp "Now Exiting the Program......"
        else
            echo -e "\n>>>> Start Script Input Error Occured">>$log;
            logUser "Sorry, I Dont Understand. Please Enter Yes Or No."
            read -p "Do You Wish To Continue? " answer
        fi
        ((counter++))
        if [ $counter -eq 3 ]; then
            logError "$counter Attempts Failed."
            logUser "Please Try Again Later."
            sleep 1
            exit 1
        fi
    done
}
StartScript
runscript=$?
if [ $runscript -eq 0 ]; then
    getUserInput;
    result=$?;
    if [ $result -eq 1 ]; then
        counter=1
        until [ $counter -eq 3 ]
        do
            log "An Input Error Occured."
            read "Would You Like To Try Again? " tryagain
            case $tryagain in
                y | Y | Yes | yes | YES)
                    counter=3
                    StartScript
                ;;
                n | N | NO | no | 0)
                    exitapp
                ;;
                *)
                    ((counter++))
                    log "Sorry I Did Not Understand, Please Enter Yes or No"
                ;;
            esac
        done
    else
        exitapp
    fi
    exitapp
fi
