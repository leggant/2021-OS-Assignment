#!/bin/bash

#default="http://kate.ict.op.ac.nz/~faisalh/IN617linux/users.csv"
default="https://github.com/leggant/2021-OS-Assignment/blob/assignment-code/users.csv"
# Check Download URI resource, check it starts with http:// 
# and ends in .csv
checkCSV_URI() {
    echo $1
}

# Download Default user.csv
downloadDefaultCSV() {
    echo $1
}

checkFileExists() {
    echo "checking"
    FILE=$1
    if [ -f "$FILE" ]; then
        echo -e "$FILE exists.    " 
    else 
        echo "$FILE does not exist."
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

echo -e "\nThis script will auto new user creation on this system. Do you wish to: \n
1) Download and Use the Default CSV File 
2) Enter a New URL to a CSV File For Download
3) Exit The Program
"

x=1
until [[ $x -eq 5 || $option -ge 1 && $option -le 3 ]]
do
    read -p "Enter 1, 2 or 3: " option
    case $option in 
        1) 
            echo -e "\tChecking Users CSV File URL\n";
            checkCSV_URI $default;
            echo -e "\tDownloading Users CSV File\n";
            downloadDefaultCSV $default;
            exit 0;;
        2) 
            echo -e "\t\nChecking Default Local User File"; 
            exit 0 ;;
        3) 
            echo -e "\t\nExiting The Program"; 
            exit 1 ;;
        *) 
            echo -e "\f\t>> Error, Please try again <<\n" ;;
    esac 
    x=$(( x+1 ))
    if [ $x -eq 5 ]; then
        echo -e "Input Error Please Try Again Later"
        exit 1
    fi
done

## Parse User CSV File
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
        #parse group string
        #check if group exists
        #create if not
        #add this user to group
        echo "Shared Folder: $shared"
    done
} < $FILE