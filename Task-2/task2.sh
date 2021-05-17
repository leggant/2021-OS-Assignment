#!/bin/bash
StartScript() {
echo -e "\n#####################################\n###### Directory Backup Script ######\n#####################################\n"
echo -e "This Script Will Compress a Directory of Your Choosing and Backup This File To A Remote Server\n"
read -pr "Do You Wish To Continue? " continue

if [[ $continue == "yes" ||
        $continue == "y" ||
        $continue == "YES" ||
    $continue == "Y" ]]; then
    echo "$continue ok"
    elif [[ $continue == "no" ||
        $continue == "n" ||
        $continue == "NO" ||
    $continue == "N" ]]; then
    echo "$continue no"
else
    echo "Sorry I Dont Understand"
fi

}

StartScript