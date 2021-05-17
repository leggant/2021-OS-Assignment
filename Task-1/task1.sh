#!/bin/bash

# ---------------------------------------------------------------------------- #
#                         GLOBAL VARIABLE DECLARATIONS                         #
# ---------------------------------------------------------------------------- #

default="http://kate.ict.op.ac.nz/~faisalh/IN617linux/users.csv"
downloaded="users.csv"
local="test.csv"
log="log.txt"
newPath=""

# ---------------------------------------------------------------------------- #
#                         SCRIPT FUNCTION DECLARATIONS                         #
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
#          CHECK THE LOCALLY STORED FILE IS BOTH PRESENT AND PARSABLE          #
# ---------------------------------------------------------------------------- #

checkAndParseLocalCSV() {
    echo -e "#### Checking The Default Local User File">>$log;
    checkFile $local
    ok=$?
    if [ $ok -eq 0 ]; then
        echo -e "#### $local Is Ok To Parse User Data From">>$log;
        echo -e "#### $local Is Ok To Parse User Data From\n";
        ConfirmUserNumber $local;
        # user asked to continue creating x users
        ok=$?;
        if [ $ok -eq 0 ]; then
            parseData $local;
        elif [ $ok -eq 1 ]; then
            startMenu
        fi
    else 
        until [[ $x -eq 3 || $ok -eq 0 ]]
        do
            read -p "Enter A New File Path Here:: " newPath 
            checkFile "$newPath";
            ok=$?;
            if [ $ok -eq 0 ]; then
                local=$newPath;
                ConfirmUserNumber $local;
                ok=$?;
                if [ $ok -eq 0 ]; then
                    parseData $local;
                fi
            else
                x=$(( x+1 ))
                if [ $x -eq 3 ]; then
                    echo -e "\n>>>> Input Error Please Try Again Later";
                    exit 1;
                fi
            fi
        done
    fi
}

# ---------------------------------------------------------------------------- #
#             CHECK IF THE FILE IS ON THE SYSTEM AND CAN BE PARSED             #
# ---------------------------------------------------------------------------- #

checkFile() {
    if [[ -f $1 && -r $1 && -s $1 && ${1: -4} == ".csv" ]]; then
        
 	    echo -e "\n#### $1 is a readable CSV file that contains parsable content. ####\n\n#### Parsing $1 ####\n"
        return 0
    else 
        echo -e "\n>>>> ERROR <<<< $1 does not exist locally or is not a CSV file.\n">>$log
        echo -e "\n>>>> ERROR >>>> $1 does not exist locally or is not a CSV file.\n"
        return 1
    fi
}

# ---------------------------------------------------------------------------- #
#           CHECK URL TO CSV FILE AND DOWNLOAD CSV FILE IF URL IS OK           #
# ---------------------------------------------------------------------------- #

checkAndDownloadCSV() {
    echo -e "\n#### Checking If Users File Is Already Downloaded ####"
    checkFile $downloaded
    ok=$?
    if [ $ok -eq 0 ]; then
        echo -e "\n$downloaded Is Already On The Local System\nCSV Contains Content and Is Parsable">>$log;
        echo -e "\n#### $download Is Already Present In The Local File System ####\n#### CSV Contains Content and Is Parsable ####";
        ConfirmUserNumber $downloaded;
    else 
        echo -e "#### Checking User CSV File URL ####";
        checkCSV_URI $default 2>>$log;
        URLok=$?
        if [ $URLok -eq 0 ]; then
            echo -e "\n#### CSV File URL Checked and OK ###">>$log;
            echo -e "#### Downloading Users CSV File ####\n";
            downloadDefaultCSV $default 2>>$log;
            if [ $? -eq 1 ]; then
                echo -e "#### Download Complete ####\n";
                echo -e "#### Checking Downloaded CSV File ####\n";
                checkFile $downloaded;
                ok=$?
                if [ $ok -eq 0 ]; then 
                    ConfirmUserNumber $downloaded;
                fi
            else
                errorOut "\n>>>\n>>>Error During Download. Please Try Again<<<\n<<<";
            fi
        else 
            errorOut "\n>>>\n>>>There is A Issue With The Resource URL Preventing File Download\n>>>Please Try Again Using a Local File\n<<<"
        fi
    fi
}

# ---------------------------------------------------------------------------- #
#               Check Download URI resource, check it starts with              #
#                           http:// and ends in .csv                           #
# ---------------------------------------------------------------------------- #

checkCSV_URI() {
    if wget --spider $1 2>> $log; then
        echo -e "\n#### This file exists and is downloadable. ####";
        return 0
    else
        echo -e "\n>>>>\n>>>>ERROR This File/URL Does Not Exist. <<<<\n<<<<"
        return 1
    fi
}

# ---------------------------------------------------------------------------- #
#              DOWNLOAD THE CSV FILE FROM THE DEFAULT URL RESOURSE             #
# ---------------------------------------------------------------------------- #

downloadDefaultCSV() {
    if wget - $default 2>>$log; then
        echo -e "\n#### $default CSV File Download Completed.....";
        return 0;
    else
        return 1;
    fi
}

# ---------------------------------------------------------------------------- #
#        CONFIRM THE USER WISHES TO CREATE X NUMBER OF USERS IN THE FILE       #
# ---------------------------------------------------------------------------- #

ConfirmUserNumber() {
    x=1;
    userNum=$(awk '{n+=1} END {print n}' $1);
    Num="$(( $userNum-1 ))"
    echo -e "# ---------------------------------------------------------------------------- #"
    echo -e "# ------------This Script Is Now Ready to Create $Num Users.------------------ #"
    echo -e "# ---------------------------------------------------------------------------- #"
    while [[ $x -le 3 ]]; do
        read -p "Do You Wish to Proceed? " confirm;
        case $confirm in
            Y | Yes | y | yes)
                echo -e "\nProceeding....";
                return 0;
            ;;
            N | No | n | no)
                errorOut "\nExiting The Program....";
            ;;
            *)
                echo -e "\nPlease enter yes or no...\n";
                if [ $x -eq 3 ]; then
                    errorOut "An Error Occured During Confirmation. Please try Again";
                fi
            ;;
        esac
        x=$(( x+1 ))
    done
}

# ----------------- If Successful, THen Check & Parse CSV file ---------------- #
# ---------------------------- Parse User CSV File ---------------------------- #

parseData() {
    {
        read -r
        while IFS=";" read -r email dob group shared
        do
            ## Check if Group(s) Exist
            ## This will call a second function if
            ## the group does not exist
            checkIfGroupExists $group
            ## Parsing Users Password From DOB
            password=$(date -d $dob +'%m%Y')
            echo -e "\nConverting $dob to Password: $password"
            ## Creating Shared Folder If It Does Not Exist
            # Remove '/' from shared
            folder=$(echo "$shared" | awk -F/ '{print $NF}')
            # check if folder exists

            createSharedFolder $folder
            ## Create User Name From Email
            xname=$email
            initial=${xname:0:1}
            last=$(echo "$xname" | cut -d"@" -f1 | cut -d"." -f2)
            name=$initial$last
            echo "Converted $xname to username: $name"
            ## Check If User Name Exists
            checkIfUserExists $name
            ok=$?
            if [ $ok -eq 0 ]; then
                # create user with all parsed params
                createUser $name $password 
                ok=$?
                echo $ok
                #if [ $ok -eq 0 ]; then
                    # add user to groups
                #elif [ $ok -eq 1 ]; then
                    #continue
                #fi
            elif [ $ok -eq 1 ]; then 
                continue
            fi
        done
    } < $1
}

# ---------------------------------------------------------------------------- #
#              CHECK IF A GROUP EXISTS, CREATE THIS IF IT DOES NOT             #
# ---------------------------------------------------------------------------- #

checkIfGroupExists() {
    IFS=',' read -r -a groups <<< $1
    for group in "${groups[@]}"
    do
        egrep -iq $group /etc/group;
        ok=$?
        if [ $ok -eq 0 ]; then
            echo -e "\n>>> Group: $group already exists";
        else
            echo -e "\n>>> Group: $group does not exist";
            createNewGroup $group;
        fi
    done
}

createNewGroup () {
    echo -e "Making Group >> $1";
    echo "Making Group >> $1" >> $log;
    sudo groupadd $1
}

# ---------------------------------------------------------------------------- #
#         CHECK IF A USER CURRENTLY EXISTS, CREATE USER IF THEY DO NOT         #
# ---------------------------------------------------------------------------- #

checkIfUserExists() {
    if id -un $1 2>>$log; then
        echo "$1 already exists"
        return 1;
    else
        echo "user does not exist"
        return 0;
    fi
}

createUser() {
    echo -e "Create New User $1";
    sudo useradd -d /home/$1 -m -s /bin/bash $1 2>>$log;
    passwd -e $2 $1 2>>$log;
    return $?
}

checkSharedFolderExists() {
    echo "Checking Shared Directory"
}

createSharedFolder() {
    dir=$1
    #mkdir -p $dir
    echo "Shared Folder Created $dir"
}

# For each user with permission to a shared folder, create a link in the users home folder to the shared directory. Link name: 'shared'
createSharedFolderLink() {
    echo "Link Created"
}

# ------------------------ CREATE ALIAS FOR EACH USER ------------------------ #
# ------------------------- THAT HAS SUDO PERMISSIONS ------------------------ #

createUsersAlias() {
    echo alias 'off="systemctl poweroff"' >> ~.bash_aliases
}

errorOut() {
    message=$1;
    echo -e "$message";
    echo -e "\n>>>> $message">>$log;
    exit 1
}

# ---------------------------------------------------------------------------- #
#                        Start of Program Output To User                       #
# ---------------------------------------------------------------------------- #

# echo -e "\nThis script will auto new user creation on this system. Do you wish to: \n
# 1) Download and Use the Default CSV File 
# 2) Use a Locally Stored CSV File
# 3) Exit The Program
# "

# x=1
# until [[ $x -eq 4 || $option -ge 1 && $option -le 3 ]]
# do
#     read -p "Enter 1, 2 or 3: " option
#     case $option in 
#         1) 
#             checkAndDownloadCSV 
#             ok=$?
# 	        if [ $ok -eq 0 ]; then
# 		        parseData $downloaded;
#             fi  ;;
#         2) 
#             checkAndParseLocalCSV 
#             ok=$?
#             if [ $ok -eq 0 ]; then
#                 parseData $local;
#             fi ;;
#         3) 
#             echo -e "\t\nExiting The Program"; 
#             exit 1 ;;
#         *) 
#             echo -e "\f\t>> Error, Please try again <<\n" ;;
#     esac 
#     x=$(( x+1 ))
#     if [ $x -eq 4 ]; then
#         echo -e "Input Error Please Try Again Later"
#         exit 1
#     fi
# done

startMenu() {
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
                ok=$?
                if [ $ok -eq 0 ]; then
                    parseData $downloaded;
                fi  ;;
            2) 
                checkAndParseLocalCSV 
                ok=$?
                if [ $ok -eq 0 ]; then
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
}

startMenu