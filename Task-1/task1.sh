#!/bin/bash

# ---------------------------------------------------------------------------- #
#                         GLOBAL VARIABLE DECLARATIONS                         #
# ---------------------------------------------------------------------------- #

default="http://kate.ict.op.ac.nz/~faisalh/IN617linux/users.csv"
downloaded="users.csv"
local="LocalUser.csv"
log="log.txt"
newPath=""
ok=0

# ---------------------------------------------------------------------------- #
#                         SCRIPT FUNCTION DECLARATIONS                         #
# ---------------------------------------------------------------------------- #

checkAndDownloadCSV() {
    echo -e "\n>>> Checking If Users File Is Already Downloaded <<<"
    checkFile $downloaded
    present=$?
    if [ $present -eq 0 ]; then
        echo -e ">>> $downloaded Is Already On The Local System\n">>$log;
        echo -e "\n>>> File Is Already Downloaded To The Local System";
        echo -e ">>> Parsing this Downloaded CSV File\n";
    else 
        echo -e ">>> Checking User CSV File URL";
        checkCSV_URI $default 2>>$log;
        URLok=$?
        if [ $URLok -eq 0 ]; then
            echo -e "CSV File URL Checked and OK">>$log;
            echo -e "\nDownloading Users CSV File\n";
            downloadDefaultCSV $default 2>>$log;
        else 
            echo -e "\n\t>>> An Error Occured During Download\n\t>>> Please Try Again Later <<<";
            echo -e "An Error Occured During Download\n>>> Exiting The Program">>$log;
            exit 1
        fi
    fi
}

checkAndParseLocalCSV() {
    echo -e "\nChecking Default Local User File \n";
    echo -e ">>> Checking The Default Local User File">>$log;
    checkFile $local
    ok=$?
    if [ $ok -eq 0 ]; then
        echo -e ">>> $local is ok to parse user data from">>$log;
        echo -e ">>> $local is ok to parse user data from";
        return 0
    else 
        x=0
        ok=1
        echo -e "Error Parsing User Data From Local File";
        until [[ $x -eq 3 || $ok -eq 0 ]]
        do
            read -p "Enter A New File Path Here:: " newPath 
            checkFile $newPath
            if [ $? -eq 0 ]; then
                local=$newPath;
                checkAndParseLocalCSV 
            else
                x=$(( x+1 ))
                if [ $x -eq 3 ]; then
                    echo -e "Input Error Please Try Again Later";
                    exit 1
                fi
            fi
        done
    fi
}

# Check Download URI resource, check it starts with http:// 
# and ends in .csv
checkCSV_URI() {
    if wget --spider "${1}" 2>> $log; then
        echo "This file exists and is downloadable.";
        return 0
    else
        echo -e ">>> This File/URL Does Not Exist. <<<"
        return 1
    fi
}

# Download Default user.csv
downloadDefaultCSV() {
    if wget - $default 2>> $log; then
        echo -e "$default CSV File Download Completed.....">>$log;
        echo -e "\n$default CSV File Download Completed....."
        return 0;
    else
        return 1;
    fi
}

checkFile() {
    if [[ -f $1 && -r $1 && -s $1 && ${1: -4} == ".csv" ]]; then
        echo -e "$1 is readable and contains parsable content.\n">>$log
        return 0
    else 
        echo -e "\n>>> $1 does not exist locally or is not a CSV file.\n"
        return 1
    fi
}

checkIfGroupExists() {
    if grep -q $1 /etc/group 2>> $log; then
        echo "$1 already exists"
    else
        echo "$1 does not exist"
    fi
}

createGroup () {
    echo $1
}

checkIfUserExists() {
    if id -u "$1" >>$log; then
        echo "user exists"
    else
        echo "user does not exist"
    fi
}

createUserName() {
    xname=$1
    initial=${xname:0:1}
    last=$(echo $xname | cut -d"@" -f1 | cut -d"." -f2)
    name=$initial$last
    echo "Converted $1 to username: $name"
    echo $name
}

createSharedFolder() {
    echo "Shared Folder Created"
}

createSharedFolderLink() {
    echo "Link Created"
}

# ---------------------------------------------------------------------------- #
#                        Start of Program Output To User                       #
# ---------------------------------------------------------------------------- #

echo -e "\nThis script will auto new user creation on this system. Do you wish to: \n
1) Download and Use the Default CSV File 
2) Use a Locally Stored CSV File
3) Exit The Program
"

x=1
until [[ $x -eq 4 || $option -ge 1 && $option -le 3 ]]
do
    read -p "Enter 1, 2 or 3: " option
    case $option in 
        1) 
            checkAndDownloadCSV ;;
        2) 
            checkAndParseLocalCSV ;;
        3) 
            echo -e "\t\nExiting The Program"; 
            exit 1 ;;
        *) 
            echo -e "\f\t>> Error, Please try again <<\n" ;;
    esac 
    x=$(( x+1 ))
    if [ $x -eq 4 ]; then
        echo -e "Input Error Please Try Again Later"
        exit 1
    fi
done

# ----------------- If Successful, THen Check & Parse CSV file ---------------- #
# ---------------------------- Parse User CSV File ---------------------------- #

parseUsers() {
    {
        read
        while IFS=";", read -r email dob group shared
        do
            createUserName $email
            password=$(date -d $dob +'%m%Y')
            echo "Converting $dob to Password: $password"
            echo "Converting $email to username:"
            echo "Groups: $group"
            echo "Shared Folder: $shared"
        done
    } < $local
}

# ------------------------ CREATE ALIAS FOR EACH USER ------------------------ #
echo 'alias off=”systemctl poweroff”' >> ~/.bashrc