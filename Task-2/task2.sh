#!/bin/bash

currentPath=$(pwd)
currentFileName=$(echo "${currentPath##*/}")
userInputDirectory=""
outputFileName="default"
inputIP=""
port=22
destinationPath=""
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
    sleep 2;
}

quit() {
    read -p "Do You Want To Continue? Enter 'q' to quit or 'c' to continue" answer
}

# ---------------------------------------------------------------------------- #
#      GET INPUT FROM USERS TO SELECT A FILE, OUTPUT FILE AND REMOTE HOST      #
# ---------------------------------------------------------------------------- #

# Destination Ip
getDestinationIP() {
    count=0
    while [ $count -le 3 ]
    do
        clear
        read -p "Enter the destination IP address: " ip;
        read -p "Enter the destination Host Username: " host;
        inputIP="$host:$ip" 
        logUser "You Have Entered The Following Destination IP: $inputIP" 
        read -p "Confirm These Details Are Correct: " confirm
        if [[ ${#confirm} -eq 0 ]]; then
            count=4;
            return 0;
        elif [[ $confirm = "y" || $confirm = "yes" || $confirm = "Y" || $confirm = "YES" ]]; then
            count=4;
            return 0;
        elif [[ $confirm = "n" || $confirm = "no" || $confirm = "N" || $confirm = "NO" ]]; then
            inputIP="";
            host="";
            ip="";
            ((count=count+1));
        else 
            ((count=count+1));
            logError "Please Enter Yes Or No.....";
        fi
        if [ $count -eq 3 ]; then
            logError "Incorrect IP Details Entered $count Times, Please Try Again";
            inputIP="";
            host="";
            ip="";
            return $1;
        fi
    done
}

# file name
getZipFileName() {
    count=0
    while [ $count -le 3 ]
    do
        read -p "Enter the Output Filename Here, or Press Enter To Use 'Default.tar.gz':: " output
        if [[ ${#output} -eq 0 ]]; then
            outputFileName="Default";
        elif [[ ! ${#output} -eq 0 ]]; then 
            outputFileName="$output";
        fi
        logUser "You Have Entered The Following File Name: $outputFileName" 
        read -p "Confirm These Details Are Correct: " confirm
        if [[ ${#confirm} -eq 0 ]]; then
            count=4;
            return 0;
        elif [[ $confirm = "y" || $confirm = "yes" || $confirm = "Y" || $confirm = "YES" ]]; then
            count=4;
            return 0;
        elif [[ $confirm = "n" || $confirm = "no" || $confirm = "N" || $confirm = "NO" ]]; then
            outputFileName="Default";
            ((count=count+1));
        else 
            ((count=count+1));
            logError "Please Enter Yes Or No....." ;
        fi
        if [ $count -eq 3 ]; then
            logError "Incorrect Input Entered $count Times, Please Try Again";
            outputFileName="Default";
            return 1;
        fi
    done
}

# destination folder
getDestinationDirectory() {
    count=0
    while [ $count -le 3 ]
    do
        clear
        logUser "Enter the full path to the directory you would like to transfer"
        read -p "to on the remote host. example: '/home/yourname/documents' :: " path
        if [[ ${#path} -eq 0 ]]; then
            ((count=count+1));
            continue;
        elif [[ ! ${#path} -eq 0 ]]; then
            destinationPath=$path
            logUser "You Have Entered The Following Destination Directory Path: $destinationPath" 
            read -p "Confirm These Details Are Correct: " confirm
            if [[ ${#confirm} -eq 0 ]]; then
                count=4;
                return 0;
            elif [[ $confirm = "y" || $confirm = "yes" || $confirm = "Y" || $confirm = "YES" ]]; then
                count=4;
                return 0;
            elif [[ $confirm = "n" || $confirm = "no" || $confirm = "N" || $confirm = "NO" ]]; then
                destinationPath="";
                ((count=count+1));
            elif [ $count -eq 3 ]; then
                logError "Incorrect Path Entered $count Times, Please Try Again";
                destinationPath="";
                return 1;
            else 
                ((count=count+1));
                logError "Please Enter Yes Or No.....";
            fi
        else
            logError "Incorrect Path Entered $count Times, Please Try Again";
            destinationPath="";
            StartScript;
        fi
    done
}

getPortNumber() {
    count=0
    while [ $count -le 3 ]
    do
        clear
        logUser "The Default Port For SSH is 22."
        read -p "Press Enter If You Wish To Use This Port, or Enter A New Port Number Here: " newport
        if [[ ${#newport} -eq 0 ]]; then
            port=22;
        else 
            port=$newport;
        fi
        read -p "You Have Entered Port# $port - Confirm Yes or No: " confirm;
        if [[ ${#confirm} -eq 0 ]]; then
            logUser "Port $port Confirmed";
            port=$newport;
            count=4;
            return 0;
        elif [[ $confirm = "y" || $confirm = "yes" || $confirm = "Y" || $confirm = "YES" ]]; then
            count=4;
            return 0;
        elif [[ $confirm = "n" || $confirm = "no" || $confirm = "N" || $confirm = "NO" ]]; then
            port=22;
            ((count=count+1));
        else 
            ((count=count+1));
            logError "Please Enter Yes Or No.....";
        fi
        if [ $count -eq 3 ]; then
            logError "Incorrect Port Entered $count Times, Please Try Again";
            port=22;
            return 1;
        fi
    done

}

# zip the file
createZip() {
    #Delete previous file if it exists to prevent a duplicate file getting created.
    if [ -f "$outputFileName".tar.gz ]; then
        rm "$outputFileName".tar.gz;
    fi 
    tar -czvf "$outputFileName".tar.gz $userInputDirectory 2>>$log;
    return 0;
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

confirmContinue() {
    count=0
    while [ $count -le 3 ]
    do
        clear
        logUser "$outputFileName.tar.gz is now ready to be transferred: $host:$ip Path: $destinationPath";
        read -p "Do You Want To Proceed? Enter Y or N: " confirm
        if [[ ${#confirm} -eq 0 ]]; then
            count=4;
            return 0;
        elif [[ $confirm = "y" || $confirm = "yes" || $confirm = "Y" || $confirm = "YES" ]]; then
            count=4;
            return 0;
        elif [[ $confirm = "n" || $confirm = "no" || $confirm = "N" || $confirm = "NO" ]]; then
            count=4;
            return 1;
        else 
            ((count=count+1));
            logError "Please Enter Yes Or No.....";
        fi
        if [ $count -eq 3 ]; then
            logError "Incorrect Path Entered $count Times, Please Try Again";
            return 1;
        fi
    done
}

sendToRemoteHost() {
    logUser "Sending $outputFileName to $ip";
    scp -P $port "$outputFileName".tar.gz "$host"@"$ip":"$destinationPath">>$log;
    [[ $? -eq 0 ]] && logUser "$outputFileName.tar.gz Can now be unzipped on the remote host using the command: sudo tar -xzvf $outputFileName.tar.gz" 
    pause
    return $?;
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
        [[ $ok -eq 1 ]] && logUser "An Input Error Occured, Please Try Again" && askUserForDirectory;
        [[ $ok -eq 0 ]] && getZipFileName
        ok=$?;
        pause
        [[ $ok -eq 1 ]] && logUser "An Input Error Occured, Please Try Again" && getZipFileName;
        [[ $ok -eq 0 ]] && logUser "Output File Name: $outputFileName" && createZip;
        ok=$?;
        pause
        [[ $ok -eq 1 ]] && logUser "An Input Error Occured, Please Try Again" && createZip;
        [[ $ok -eq 0 ]] && logUser "Zip File Successfully Created." && getDestinationIP;
        ok=$?;
        pause
        [[ $ok -eq 1 ]] && logUser "An Input Error Occured, Please Try Again" && getDestinationIP;
        [[ $ok -eq 0 ]] && logUser "Destination IP Confirmed: $inputIP" && getDestinationDirectory;
        ok=$?;
        pause
        [[ $ok -eq 1 ]] && logUser "An Input Error Occured, Please Try Again" && getDestinationDirectory;
        [[ $ok -eq 0 ]] && logUser "Destination Directory Confirmed: $destinationPath" && getPortNumber;
        ok=$?;
        pause
        [[ $ok -eq 1 ]] && logUser "An Input Error Occured, Please Try Again" && getPortNumber;
        [[ $ok -eq 0 ]] && logUser "Port Confirmed: $port" && confirmContinue;
        ok=$?;
        pause
        [[ $ok -eq 1 ]] && logUser "Aborting Transfer.......";
        [[ $ok -eq 0 ]] && logUser "Starting Transfer......." && sendToRemoteHost;
        ok=$?;
        pause
        [[ $ok -eq 1 ]] && logError "An Error Occured During Transfer, Check Your Input Credentials and Try Again" && StartScript;
        [[ $ok -eq 0 ]] && exitapp "Program Has Successfully Compressed $outputFileName and Transferred to $inputIP" && pause;
    done
    exitapp "Come Back Soon :)";
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
            clear;
            return 0;
            elif [[ $answer = "no" || $answer = "n" || $answer = "NO" || $answer = "N" ]]; then
            exitapp "# ----------------------- Now Exiting the Program...... ---------------------- #";
        else
            echo -e "\n>>>> Start Script Input Error Occured">>$log;
            logUser "Sorry, I Dont Understand. Please Enter Yes Or No.";
            read -p "Do You Wish To Continue? " answer
        fi
        ((counter++));
        if [ $counter -eq 3 ]; then
            logError "$counter Attempts Failed.";
            logUser "Please Try Again Later.";
            sleep 1;
            exit 1;
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
    fi
else
    exitapp "# -------------------------- NOW EXITING THE PROGRAM ------------------------- #"
fi