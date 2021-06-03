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
    echo -e "\n$message";
    echo -e "\n$message">>$log;
}
exitapp() {
    echo -e "\n\n# ---------------------------------------------------------------------------- #"
    echo $1
    echo -e "# ---------------------------------------------------------------------------- #\n\n"
    pause
    echo "Exiting the Program.....">>$log;
    clear
    exit 1
}

pause() {
    sleep 4;
}

# ---------------------------------------------------------------------------- #
#      GET INPUT FROM USERS TO SELECT A FILE, OUTPUT FILE AND REMOTE HOST      #
# ---------------------------------------------------------------------------- #

# Destination Ip
getDestinationIP() {
    count=0
    
    while [ $count -le 3 ]
    do
        error=0
        read -p "Enter the destination IP address: " ip;
        [[ ${#ip} -eq 0 ]] && error=1 || error=0;
        read -p "Enter the destination Host Username: " host;
        [[ ${#host} -eq 0 ]] && error=1;
        if [[ $error -eq 0 ]]; then 
            inputIP="$host:$ip" 
            logUser "You Have Entered The Following Destination IP: $inputIP" 
            read -p "Confirm These Details Are Correct: " confirm
            [[ ${#confirm} -eq 0 ]] && return 0;
            case $confirm in
                y | Y | Yes | yes | YES )
                    return 0;
                ;;
                n | N | NO | no )
                    let "count+=1"
                    inputIP=""
                    if [ $count -eq 3 ]; then
                        logError "Incorrect IP Details Entered $count Times, Please Try Again"
                        return 1;
                    fi        
                ;;
            esac
        else
            logUser "Input Error, Please Try Again"
        fi
    done
}

# file name
getZipFileName() {
    read -p "Enter the Output Filename Here, or Press Enter To Use 'Default.tar.gz':: " output
    [[ ${#output} -ne 0 ]] && outputFileName=$output && return 0;
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
    #Delete previous file if it exists to prevent a duplicate file getting created.
    if [ -f "$outputFileName.tar.gz" ]; then
        rm "$outputFileName.tar.gz";
    fi 
    tar -czvf "$outputFileName.tar.gz" $userInputDirectory 2>>$log;
    echo $?
    return $?
}

askUserForDirectory() {
    echo -e "\nEnter the full path to the directory you would like to compress and transfer"
    read -p "or press enter if you wish to use the current path: " path
    ok=1
    if [[ ${#path} -eq 0 ]]; then
        userInputDirectory=$currentPath;
        checkDirectoryExists $userInputDirectory;
        ok=$?;
        return $ok;
    elif [[ ! ${#path} -eq 0 ]]; then
        userInputDirectory=$path
        checkDirectoryExists $userInputDirectory;
        ok=$?;
        return $ok;    
    fi
}
sendToRemoteHost() {
    echo "Sending $outputFileName to......."
    #scp -P 22 default.tar.gz #username@ipaddress : inputfiledirectoryonremote
}

checkRemoteOnline() {
    echo "check remote ip wget?"
}

inputLoop() {
    question=$?
    answer=""
    counter=1
    until [ $counter -eq 3 ]
    do
        if [[ $answer = "yes" || $answer = "y" || $answer = "YES" || $answer = "Y" ]]; then
            clear
            return 0
            elif [[ $answer = "no" || $answer = "n" || $answer = "NO" || $answer = "N" ]]; then
            exitapp "# ----------------------- Now Exiting the Program...... ---------------------- #";
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

checkDirectoryExists() {
    [[ -d $1 ]] && logUser "$1 directory exists!" && userInputDirectory=$1 && return 0;
    [[ ! -d $1 ]] && logError "Error>>> $1 directory Does Not Exist!." && return 1;
}

getUserInput() {
    counter=0;
    ok=0;
    while [ $counter -le 3 ]
    do
        askUserForDirectory
        ok=$?;
        [[ $ok -eq 1 ]] && logUser "An Input Error Occured, Please Try Again" && let "counter+=1" && askUserForDirectory;
        [[ $ok -eq 0 ]] && getZipFileName && ok=$?;
        pause
        [[ $ok -eq 1 ]] && logUser "An Input Error Occured, Please Try Again" && let "counter+=1" && getZipFileName;
        [[ $ok -eq 0 ]] && logUser "Output File Name: $outputFileName" && createZip && ok=$?;
        pause
        [[ $ok -eq 1 ]] && logUser "An Input Error Occured, Please Try Again" && let "counter+=1" && createZip;
        [[ $ok -eq 0 ]] && logUser "Zip File Successfully Created." && getDestinationIP && ok=$?;
        pause
        # ZIP file

        #getDestinationIP;
        #ok=$?;
        # get destination directory

        # get port number for transfer

        # check host is available

        # confirm proceeding

        [[ $ok -eq 0 ]] && exitapp "Program Has Successfully Compressed $outputFileName and Transferred to $inputIP"
    done
}

StartScript() {
    clear
    echo "#------------------------------------------------------------------------------#"
    echo "#-----------------------AUTOMATED DIRECTORY BACKUP SCRIPT----------------------#"
    echo "#------------------------------------------------------------------------------#"
    echo -e "\n\nThis Script Will Compress a Directory of Your Choosing and Backup This File To A Remote Server\n"
    read -p "Do You Wish To Continue? " answer
    counter=1
    until [ $counter -eq 3 ]
    do
        if [[ $answer = "yes" || $answer = "y" || $answer = "YES" || $answer = "Y" ]]; then
            clear
            return 0
            elif [[ $answer = "no" || $answer = "n" || $answer = "NO" || $answer = "N" ]]; then
            exitapp "# ----------------------- Now Exiting the Program...... ---------------------- #";
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
            logError "An Input Error Occured."
            read -p "Would You Like To Try Again? " tryagain
            case $tryagain in
                y | Y | Yes | yes | YES)
                    clear
                    getUserInput
                ;;
                n | N | NO | no | 0)
                    clear
                    exitapp "# -------------------------- NOW EXITING THE PROGRAM ------------------------- #"
                ;;
                *)
                    ((counter++))
                    logUser "Sorry I Did Not Understand, Please Enter Yes or No"
                ;;
            esac
        done
    else
        pause
        logUser "Ready to Transfer Your File >>>>"
        sendToRemoteHost
    fi
else
    exitapp "# -------------------------- NOW EXITING THE PROGRAM ------------------------- #"
fi
