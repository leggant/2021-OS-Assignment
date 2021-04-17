#!/bin/bash

echo -e "\n#####################################\n###### Directory Backup Script ######\n#####################################\n"

echo -e "This Script Will Compress a Directory of Your Choosing and Backup This File To A Remote Server\n"

read -p "Do You Wish To Continue? " continue
if [[ $continue -eq "yes" || $continue -eq "y" || $continue -eq "YES" || $continue -eq "Y" ]]; then
    echo "$continue ok"
elif [[ $continue -eq "no" || $continue -eq "n" || $continue -eq "NO" || $continue -eq "N" ]]; then
    echo "$continue no"
else
    echo "Sorry I Dont Understand"
fi