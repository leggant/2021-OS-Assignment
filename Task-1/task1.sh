#!/bin/bash
# ---------------------------------------------------------------------------- #
#                         GLOBAL VARIABLE DECLARATIONS                         #
# ---------------------------------------------------------------------------- #
default="http://kate.ict.op.ac.nz/~faisalh/IN617linux/users.csv"
#default="http://127.0.0.1:5500/TESTusers.csv"
#local="LocalUsers.csv"
local="TESTusers.csv"
log="log.txt"
ok=0

# ---------------------------------------------------------------------------- #
#                         SCRIPT FUNCTION DECLARATIONS                         #
# ---------------------------------------------------------------------------- #

# Check Download URI resource, check it starts with http:// 
# and ends in .csv
checkCSV_URI() {
    if wget --spider "${1}" 2>> $log; then
        echo "This page exists.";
        return 0
    else
        echo "This file does not exist."
        return 1
    fi
}

# Download Default user.csv
downloadDefaultCSV() {
    if wget - $default 2>> $log; then
        echo "$default Dowloading";
        return 0;
    else
        echo "An Error Occured";
        return 1;
    fi
}

checkAndDownloadCSV() {
    echo -e "\tChecking Users CSV File URL\n";
    checkCSV_URI $default;
    if [ $? -eq 0 ]; then
        ok=0
        echo -e "\tDownloading Users CSV File\n";
        downloadDefaultCSV $default;
    else
        echo -e "An Error has occured; Please try again";
        ok=1
    fi
}

checkFileExists() {
    if [[ -f $local && -r $local && -s $local ]]; then
        echo -e "$local exists, readable, has content."
        ok=0
    else 
        echo "$local does not exist."
        ok=1
    fi
}

checkFileIsParsable() {
    echo "also checking"
}

checkIfGroupExists() {
    if [ grep -q $1 /etc/group]; then
        echo "$1 already exists"
    else
        echo "$1 does not exist"
        # create group
    fi
}

createUserName() {
    xname=$1
    initial=${xname:0:1}
    last=$(echo $xname | cut -d"@" -f1 | cut -d"." -f2)
    name=$initial$last
    echo "Converted $1 to username: $name"
}

createGroup () {
    echo $1
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
            echo -e "\t\nChecking Default Local User File";
            checkFileExists $local ;;
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
# ---------------------------- Parse User CSV File --------------------------- #

{
    read
    while IFS=";", read -r email dob group shared
    do
        # create username from email
        # format first letter of first name followed by full last name.
        createUserName $email
        password=$(date -d $dob +'%m%Y')
        echo "Converting $dob to Password: $password"
        echo "Converting $email to username:"
        echo "Groups: $group"
        echo "Shared Folder: $shared"
    done
} < $local

# ------------------------ CREATE ALIAS FOR EACH USER ------------------------ #
echo 'alias off=”systemctl poweroff”' >> ~/.bashrc