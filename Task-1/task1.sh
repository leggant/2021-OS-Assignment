#!/bin/bash

# Download Default User.csv from Github Repo URL
downloadDefaultCSV() {
    git clone https://github.com/leggant/2021-OS-Assignment.git
    cd 2021-OS-Assignment/
    git checkout automated-io
    git status
    cp Users.csv ../
    cd ../
    #rm -rf 2021-OS-Assignment
}

checkFileExists() {
    echo "checking"
}

checkFileIsParsable() {
    echo "also checking"
}

echo -e "This script will auto new user creation on this system. Do you wish to: \n
1) download the default CSV file from GitHub\f 
2) use a locally stored CSV file?\f"

x=1
until [[ $x -eq 4 || $option -eq $x ]]
do
    read -p "Enter 1 or 2: " option
    case $option in 
        *1*) 
            echo -e "\t\nDownload Users From GitHub\n";
            downloadDefaultCSV;
            exit 0;;
        *2*) 
            echo -e "\t\nChecking Local User File"; 
            exit 0 ;;
        *) 
            echo -e "\f\t>>Error, Please try again\n" ;;
    esac 
    x=$(( x+1 ))
    if [ $x -eq 4 ]; then
        echo -e "Input Error Please Try Again Later"
        exit 1
    fi
done



# Function Declarations

# Check If Group Exists, 
# If Not, Create Group
# $1 = group

# if grep -q $1 /etc/group
#     then
#         echo "$1 already exists"
#     else
#         echo "$1 does not exist"
#         # create group
#     fi



# xname=$1
# initial=${xname:0:1}
# last=$(echo $xname | cut -d"@" -f1 | cut -d"." -f2)
# name=$initial$last
# echo "Converted $1 to username: $name"


# # Global Variables
# count=0
# gitCloneSuccess=false

# Download User.csv from Github Repo URL
# git clone https://github.com/leggant/2021-OS-Assignment.git
# cd 2021-OS-Assignment/
# git checkout automated-io
# git status

# # move file out of folder into top level dir
# # remove repo file
# cp Users.csv ../
# cd ../
# rm -rf 2021-OS-Assignment

# Check If Users File Exists - Make A Function
# FILE=Users.csv
# if [ -f "$FILE" ]; then
#     echo -e "$FILE exists.
#     " 
# else 
#     echo "$FILE does not exist."
#     echo "Please enter a new file url: "
# fi

# # Check if file is parsable. - Make A Function, 
# # change user execution persission if needed.
# # Parse User File
# {
#     read
#     while IFS=";", read -r email dob group shared
#     do
#         # create username from email
#         # format first letter of first name followed by full last name.
#         createUserName $email
#         password=$(date -d $dob +'%m%Y')
#         echo "Converting $dob to Password: $password"
#         echo "Converting $email to username:"
        
#         echo "Groups: $group"
#         #parse group string
#         #check if group exists
#         #create if not
#         #add this user to group
#         echo "Shared Folder: $shared"
#     done
# } < $FILE
