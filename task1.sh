#!/bin/bash

# Download User.csv from Github Repo URL
git clone https://github.com/leggant/2021-OS-Assignment.git
cd 2021-OS-Assignment
git checkout automated-io
git status

# move file out of folder into top level dir
mv Users.csv ../
cd ../
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


# Check if file is parsable. - Make A Function



# Parse User File

{
    read
    while IFS=";", read -r email dob group shared
    do
        password=$(date -d $dob +'%m%Y')
        echo "Password: $password"
        echo "Email: $email"
        echo "DOB: $dob"
        echo "Groups: $group"
        echo "Shared Folder: $shared"
        echo
    done
} < $FILE



# IFS=";"
# while read -r email dob group shared
# do
#     password=$(date -d $dob +'%m%Y')
#     echo "Password: $password"
#     echo "Email: $email"
#     echo "DOB: $dob"
#     echo "Groups: $group"
#     echo "Shared Folder: $shared"
#     echo

# done < $FILE


#Create User Function

# set -x will force the output of debugger
set -x
