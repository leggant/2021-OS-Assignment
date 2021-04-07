#!/bin/bash

# Global Variables

downloadSuccess=false

# Function Declarations

# Check If Group Exists, 
# If Not, Create Group
# $1 = group
checkGroup() {
if grep -q $1 /etc/group
    then
        echo "$1 already exists"
    else
        echo "$1 does not exist"
        # create group
    fi
}

createUserName() {
    name="new name"
    echo $name: $1
}

addUserToGroup() {
    echo $1
}

alternativeDownloadOnFail() {
    echo $1
}

# Download User.csv from Github Repo URL
git clone https://github.com/leggant/2021-OS-Assignment.git
cd 2021-OS-Assignment/
git checkout automated-io
git status

# move file out of folder into top level dir
cp Users.csv ../
cd ../
rm -rf 2021-OS-Assignment
pwd


# Check If Users File Exists - Make A Function
FILE=Users.csv
EXISTS=false
if [ -f "$FILE" ]; then
    echo -e "$FILE exists.\n\n" 
    cat $FILE
    echo "
    "
    $EXISTS = true
else 
    echo "$FILE does not exist."
    $EXISTS = false
    echo "Please enter a new file url: "
fi

# Check if file is parsable. - Make A Function, change user execution persission if needed.

# Parse User File

{
    read
    while IFS=";", read -r email dob group shared
    do
        # create username from email
        # format first letter of first name followed by full last name.
        echo "Converting $email to username"
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
        echo
    done
} < $FILE

#Create User Function

# set -x will force the output of debugger
set -x


