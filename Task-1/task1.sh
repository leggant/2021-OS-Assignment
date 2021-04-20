#!/bin/bash
# ---------------------------------------------------------------------------- #
#                         GLOBAL VARIABLE DECLARATIONS                         #
# ---------------------------------------------------------------------------- #
default="http://kate.ict.op.ac.nz/~faisalh/IN617linux/users.csv"
downloaded="users.csv"
local="LocalUsers.csv"
log="log.txt"
ok=0
# ---------------------------------------------------------------------------- #
#                         SCRIPT FUNCTION DECLARATIONS                         #
# ---------------------------------------------------------------------------- #

# Check Download URI resource, check it starts with http:// 
# and ends in .csv
checkCSV_URI() {
    if wget --spider "${1}" 2>> $log; then
        echo "This file exists and is downloadable.";
        return 0
    else
        echo "This file does not exist."
        return 1
    fi
}

# Download Default user.csv
downloadDefaultCSV() {
    if wget - $default 2>> $log; then
        echo -e "\n$default CSV File Download Completed....." >> $log;
        return 0;
    else
        return 1;
    fi
}

checkAndDownloadCSV() {
    echo -e "\nChecking If Users File Is Already Downloaded"
    checkFile $downloaded
    present=$?
    if [ $present -eq 0 ]; then
        echo -e "File Is Already Downloaded To The Local System\f">>$log;
        echo -e "File Is Already Downloaded To The Local System\f";
        echo -e "\tChecking Already Downloaded CSV File\n";
        checkCSV_URI $downloaded;
        URLok=$?
        if $URLok -eq 0 2>>$log; then
            echo -e "\nParsing CSV File User Data\n";
        fi
    else 
        echo -e "\tChecking Users CSV File URL\n";
        checkCSV_URI $default;
        URLok=$?
        if $URLok -eq 0 2>>$log; then
            echo -e "\nDownloading Users CSV File\n";
            downloadDefaultCSV $default;
        else 
            echo -e "\n An Error Occured During Download">>$log;
            exit 1
        fi
    fi
}

checkFile() {
    if [[ -f $1 && -r $1 && -s $1 ]]; then
        echo -e "$1 exists, readable, has content."
        return 0
    else 
        echo "$1 does not exist."
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

createUserName() {
    xname=$1
    initial=${xname:0:1}
    last=$(echo $xname | cut -d"@" -f1 | cut -d"." -f2)
    name=$initial$last
    echo "Converted $1 to username: $name"
    echo $name
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
            checkFile $local ;;
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