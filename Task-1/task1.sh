#!/bin/bash

# ---------------------------------------------------------------------------- #
#                         GLOBAL VARIABLE DECLARATIONS                         #
# ---------------------------------------------------------------------------- #

default="http://kate.ict.op.ac.nz/~faisalh/IN617linux/users.csv"
downloaded="users.csv"
local="test.csv"
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
        echo -e "$1 is a readable CSV file that contains parsable content.\n">>$log
 	    echo -e "$1 is a readable CSV file that contains parsable content.\n"
        return 0
    else 
        echo -e "\n>>>ERROR<<< $1 does not exist locally or is not a CSV file.\n">>$log
        echo -e "\n>>> $1 does not exist locally or is not a CSV file.\n"
        return 1
    fi
}

# ----------------- If Successful, THen Check & Parse CSV file ---------------- #
# ---------------------------- Parse User CSV File ---------------------------- #

parseData() {
    {
        read
        while IFS=";" read -r email dob group shared
        do
            ## Check if Group(s) Exist
            ## This will call a second function if
            ## the group does not exist
            checkIfGroupExists $group
            ## Parsing Users Password From DOB
            echo "Converting $dob to Password: $password"
            password=$(date -d $dob +'%m%Y')
            ## Creating Shared Folder If It Does Not Exist
            echo "Shared Folder: $shared"
            ## Create User Name From Email
            xname=$email
            initial=${xname:0:1}
            last=$(echo $xname | cut -d"@" -f1 | cut -d"." -f2)
            name=$initial$last
            echo "Converted $xname to username: $name"
            ## Check If User Name Exists
            checkIfUserExists $name
            if [ $? -eq 0 ]; then
                # create user with all parsed params
                echo "Create New User $name"
                sudo useradd -d /home/$name -m -s /bin/bash -p $password $name
                sudo chage -d 0 $name;
            elif [ $? -eq 1 ]; then 
                continue
            fi
        done
    } < $1
}

checkIfGroupExists() {
    IFS=',' read -r -a groups <<< "$1"
    for group in "${groups[@]}"
    do
    egrep -iq $group /etc/group;
        if [ $? -eq 0 ]; then
            echo ">>> Group: $group already exists";
        else
            echo ">>> Group: $group does not exist";
            createNewGroup $group;
        fi
    done
}

createNewGroup () {
    echo "Making Group >> $1";
    sudo groupadd $1
}

checkIfUserExists() {
    if id -un "$1" 2>>$log; then
        echo "$1 already exists"
        return 1;
    else
        echo "user does not exist"
        return 0;
    fi
}

createUser() {
    echo $1
}

newGroup() {
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
            checkAndDownloadCSV 
	        if [ $? -eq 0 ]; then
		        parseData $downloaded;
            fi  ;;
        2) 
            checkAndParseLocalCSV 
	    if [ $? -eq 0 ]; then
            parseData $local;
        fi ;;
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

# ------------------------ CREATE ALIAS FOR EACH USER ------------------------ #
echo 'alias off=”systemctl poweroff”' >> ~/.bashrc
