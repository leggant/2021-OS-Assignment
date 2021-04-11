#!/bin/bash

# Function Declarations

# Check If Group Exists, 
# If Not, Create Group
# $1 = group

if grep -q $1 /etc/group
    then
        echo "$1 already exists"
    else
        echo "$1 does not exist"
        # create group
    fi



xname=$1
initial=${xname:0:1}
last=$(echo $xname | cut -d"@" -f1 | cut -d"." -f2)
name=$initial$last
echo "Converted $1 to username: $name"


# Global Variables
count=0
gitCloneSuccess=false

# Download User.csv from Github Repo URL
git clone https://github.com/leggant/2021-OS-Assignment.git
cd 2021-OS-Assignment/
git checkout automated-io
git status

# move file out of folder into top level dir
# remove repo file
cp Users.csv ../
cd ../
rm -rf 2021-OS-Assignment

# Check If Users File Exists - Make A Function
FILE=Users.csv
if [ -f "$FILE" ]; then
    echo -e "$FILE exists.
    " 
else 
    echo "$FILE does not exist."
    echo "Please enter a new file url: "
fi

# Check if file is parsable. - Make A Function, 
# change user execution persission if needed.
# Parse User File
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
