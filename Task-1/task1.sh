#!/bin/bash

# ---------------------------------------------------------------------------- #
#                         GLOBAL VARIABLE DECLARATIONS                         #
# ---------------------------------------------------------------------------- #

default="http://kate.ict.op.ac.nz/~faisalh/IN617linux/users.csv"
downloaded="users.csv"
localfile="test.csv"
log="log.txt"
newPath=""

# ---------------------------------------------------------------------------- #
#                         SCRIPT FUNCTION DECLARATIONS                         #
# ---------------------------------------------------------------------------- #

log() {
    MESSAGE=$1
    echo -e "\n$MESSAGE"
    echo -e "\n$MESSAGE">>$log
    sleep 1
}

delay() {
    sleep 3
}

# ---------------------------------------------------------------------------- #
#                                ERROR HANDLING                                #
# ---------------------------------------------------------------------------- #

errorOut() {
    MESSAGE=$1;
    echo -e "\n$MESSAGE";
    echo -e "\n$MESSAGE">>$log;
    exit 1
}

# ---------------------------------------------------------------------------- #
#          CHECK THE LOCALLY STORED FILE IS BOTH PRESENT AND PARSABLE          #
# ---------------------------------------------------------------------------- #

checkAndParseLocalCSV() {
    echo -e "#### Checking The Default Local User File">>$log;
    checkFile $localfile
    ok=$?
    if [ $ok -eq 0 ]; then
        log "#### $localfile Is Ok To Parse User Data From"
        delay
        ConfirmUserNumber $localfile
        ok=$?
        if [ $ok -eq 0 ]; then
            parseData $localfile
        else 
            return 1
        fi
    else 
        until [[ $x -eq 3 || $ok -eq 0 ]]
        do
            read -p "Enter A New File Path Here:: " newPath 
            checkFile "$newPath"
            ok=$?
            if [ $ok -eq 0 ]; then
                localfile=$newPath;
                ConfirmUserNumber $localfile;
            else
                x=$(( x+1 ))
                if [ $x -eq 3 ]; then
                    errorOut "\n>>>> Input Error Please Try Again Later";
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
 	    log "#### $1 is a readable CSV file that contains parsable content. ####\n\n#### Parsing $1 ####"
        delay
        return 0
    else 
        log ">>>> ERROR <<<< $1 does not exist locally or is not a CSV file.";
        delay
        return 1
    fi
}

# ---------------------------------------------------------------------------- #
#           CHECK URL TO CSV FILE AND DOWNLOAD CSV FILE IF URL IS OK           #
# ---------------------------------------------------------------------------- #

checkAndDownloadCSV() {
    log "# --------------- Checking If Users File Is Already Downloaded --------------- #"
    checkFile $downloaded
    ok=$?
    echo "$ok"
    sleep 5
    if [ $ok -eq 0 ]; then
        #ask user if they want to download fresh data
        log "#### $download Is Already Present In The Local File System ####\n#### CSV Contains Content and Is Parsable ####";
        sleep 5
        #ConfirmUserNumber $downloaded;
    elif [ $ok -eq 1 ]; then
        log "# ---------- No Local Version Of File Found >> Checking Download URL --------- #";
        sleep 5
        delay
        checkCSV_URI $default 2>>$log;
        URLok=$?
        #start if 2
        if [ $URLok -eq 0 ]; then
            log "# ------------------- Remote Host/CSV File URL Checked + Ok ------------------ #";
            log "# ---------------- Downloading User Data CSV From Remote Host ---------------- #";
            delay
            downloadDefaultCSV $default;
            ok=$?
            # start if 3
            if [ $ok -eq 0 ]; then # Start if 3
                log "# -------------------------- File Download Complete -------------------------- #";
                log "# ----------------- Checking Downloaded CSV File is Parsable ----------------- #";
                checkFile $downloaded;
                ok=$?;
                if [ $ok -eq 0 ];then # start if 4
                    ConfirmUserNumber $downloaded;
                    ok=$?
                    if [ $ok -eq 0 ]; then # start if 5
                        parseData $downloaded
                    elif [ $ok -eq 1 ]; then #elif if 5
                        # ------------- >>>> An Error Occured, Returning To The Main Menu ------------ #
                        log "# ------------- >>>> An Error Occured||Returning To The Main Menu ------------ #";
                        mainMenu
                    fi # end if 5
                else
                     # ------------- >>>> An Error Occured, Returning To The Main Menu ------------ #
                    log "# ------------- >>>> An Error Occured||Returning To The Main Menu ------------ #";
                    mainMenu
                fi #End if 4
            else
                # --------------------- AN ERROR OCCURED DURING DOWNLOAD --------------------- #
                errorOut "\n# --------------------- AN ERROR OCCURED DURING DOWNLOAD --------------------- #\n
                # ------------------------------ Try Again Later ----------------------------- #";
            fi # end if 3
        fi #end if 2
    # End elif 1
    else # else if statement 1
        errorOut "\n>>>\n>>>There is A Issue With The Resource URL Preventing File Download\n>>>Please Try Again Using a Local File\n<<<"
    fi #end of function if 1
}

# ---------------------------------------------------------------------------- #
#               Check Download URI resource, check it starts with              #
#                           http:// and ends in .csv                           #
# ---------------------------------------------------------------------------- #

checkCSV_URI() {
    if wget --spider $1 2>>$log; then
        return 0
    else
        return 1
    fi
}

# ---------------------------------------------------------------------------- #
#              DOWNLOAD THE CSV FILE FROM THE DEFAULT URL RESOURSE             #
# ---------------------------------------------------------------------------- #

downloadDefaultCSV() {
    echo $1
    if wget $1 2>>$log; then
        wget $1 2>>$log;
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
    clear
    echo -e "# ---------------------------------------------------------------------------- #"
    echo -e "# ----------------The Script Is Now Ready To Create $Num Users---------------- #"
    echo -e "# ---------------------------------------------------------------------------- #\n"
    while [[ $x -le 3 ]]; do
        read -p "#### Do You Wish to Proceed? " confirm;
        case $confirm in
            Y | Yes | y | yes)
                clear
                return 0
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
# ---------------------------------------------------------------------------- #
#                  If Successful, THen Check & Parse CSV file                  #
#                              Parse User CSV File                             #
# ---------------------------------------------------------------------------- #

parseData() {
    {
        read -r
        while IFS=";" read -r email dob groups shared
        do
            password=$(date -d $dob +'%m%Y')
            log "Converting $dob to Password: $password";
            ## Create User Name From Email
            xname=$email
            initial=${xname:0:1}
            last=$(echo "$xname" | cut -d"@" -f1 | cut -d"." -f2)
            user=$initial$last
            log "Converted $xname to username: $user";
            ## Check If User Name Exists
            checkIfUserExists $user
            ok=$?
            # user does not exist, create user with all parsed params
            if [ $ok -eq 0 ]; then
                createUser $user $password 
            fi
            # Remove '/' from shared
            folder=$(echo "$shared" | awk -F/ '{print $NF}')
            userGroupConfig $groups $user $folder
            clear
        done
    } < $1
    # ---------------------------------------------------------------------------- #
    #          AT THE END OF THE SCRIPT RUN CALL FUNCTION TO LEAVE PROGRAM         #
    # ---------------------------------------------------------------------------- #
    endScript
}

# ---------------------------------------------------------------------------- #
#              CHECK IF A GROUP EXISTS, CREATE THIS IF IT DOES NOT             #
# ---------------------------------------------------------------------------- #

userGroupConfig() {
    user=$2
    folder=$3
    IFS=',' read -r -a groups <<< $1
    for group in "${groups[@]}"
    do
        egrep -iq $group /etc/group;
        ok=$?
        if [ $ok -eq 0 ]; then
            log ">>> Group: $group already exists";
        else
            log ">>> Group: $group does not exist; Creating $group";
            createNewGroup $group;
        fi
        log ">>> Adding User: $user to Group: $group";
        addUserToGroup $group $user
        log ">>> Configuring $user Access To Shared $folder via $group"
        sharedFolderConfig $folder $user $group
        log ">>> Creating Soft Link To Shared $folder For User: $user"
        createSharedFolderLink $folder $user
        log ">>> Creating Permanent Shut Down Alias For User: $user"
        createShutDownAlias $user
    done
    return 0;
}

createNewGroup () {
    sudo groupadd $1
    return $?
}

addUserToGroup() {
    sudo usermod -a -G $1 $2;
}

# ---------------------------------------------------------------------------- #
#         CHECK IF A USER CURRENTLY EXISTS, CREATE USER IF THEY DO NOT         #
# ---------------------------------------------------------------------------- #

checkIfUserExists() {
    if id -un $1; then
        log "$1 already exists"
        return 1;
    else
        log "$1 does not exist"
        return 0;
    fi
}

createUser() {
    user=$1
    password=$2
    log "Create New User: $user";
    sudo useradd -m -d /home/$user -s /bin/bash $user;

    ok=$?
    if [ $ok -eq 0 ]; then
        log "Setting Temporary Password: $password. $user Must Change This At Next Login"
        createUserPassword $user $password
        return $?
    fi
}

createUserPassword() {
    user=$1
    password=$2
    echo "$user:$password" -m | sudo chpasswd
    sudo passwd -eq $user;
    sudo chage -l $user>>$log
    return $?
}

# ---------------------------------------------------------------------------- #
#                     SHARED FOLDER CONFIGURATION FUNCTIONS                    #
# ---------------------------------------------------------------------------- #

sharedFolderConfig() {
    FOLDER="/home/$1"
    user=$2
    group=$3
    checkSharedFolderExists $FOLDER $user
    ok=$?
    if [ $ok -eq 0 ]; then
        createSharedFolder $FOLDER $user;
        setPermissions $FOLDER $user $group;
    elif [ $ok -eq 1 ]; then
        setPermissions $FOLDER $user $group;
    fi
}

# ---------------------- CHECK IF A SHARED FOLDER EXISTS --------------------- #

checkSharedFolderExists() {
    FOLDER=$1
    if [ -d $FOLDER ]; then
        log "Shared Folder: $FOLDER Already Exists";
        return 1;
    else
        log "Creating New Shared Folder: $FOLDER";
        return 0;
    fi 
}

# ----------------- CREATE SHARED FOLDER IF IT DOES NOT EXIST ---------------- #
createSharedFolder() {
    FOLDER=$1
    USER=$2
    sudo mkdir -p $FOLDER 2>>$log
}

# ---------------- ASSIGN PERMISSIONS FOR SHARED FOLDER ACCESS --------------- #
setPermissions() {
    FOLDER=$1;
    USER=$2;
    GROUP=$3;
    sudo chgrp -R $GROUP $FOLDER 2>>$log;
    sudo chmod 2770 $FOLDER 2>>$log;
    sudo chown -R root:$GROUP $FOLDER 2>>$log;
    log "Permissions for $USER Access To $FOLDER Successfully Assigned.";
}

# ---------------------------------------------------------------------------- #
#               For each user with permission to a shared folder,              #
#             create a link in the users home folder to the shared             #
#                        directory. Link name: 'shared'                        #
# ---------------------------------------------------------------------------- #

createSharedFolderLink() {
    FOLDER=$1
    USER=$2
    if [[ -L /home/$USER/shared ]]; then
        log "Shared Folder for $USER Already Exists"
    else 
        sudo ln -s $FOLDER /home/$USER/shared 2>>$log;
    fi
}

# ---------------------------------------------------------------------------- #
#             CREATE ALIAS FOR EACH USER THAT HAS SUDO PERMISSIONS             #
# ---------------------------------------------------------------------------- #

createShutDownAlias() {
    user=$1
    file=/home/$user/.bash_aliases
    sudo touch $file
    sudo chmod 777 $file;
    sudo echo alias 'off="systemctl poweroff"'>/home/$user/.bash_aliases
    sudo chown $user:$user $file
    sudo chmod 644 $file
}

# ---------------------------------------------------------------------------- #
#                                  END PROGRAM                                 #
# ---------------------------------------------------------------------------- #

endScript() {
    clear
    echo -e "# ---------------------------------------------------------------------------- #"
    echo -e "# ----------THIS SCRIPT HAS SUCCESSFULLY CREATED USERS ON THE SYSTEM---------- #"
    echo -e "# ---------------------------------------------------------------------------- #"
    delay
    clear
    sudo cat /etc/group>>$log
    sudo cat /etc/passwd>>$log
exit 1
}

# ---------------------------------------------------------------------------- #
#                        Start of Program Output To User                       #
# ---------------------------------------------------------------------------- #

mainMenu() {
    clear
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
                clear
                checkAndDownloadCSV 
                ok=$?
                if [ $ok -eq 0 ]; then
		            parseData $downloaded;
                fi  ;;
            2) 
                clear
                checkAndParseLocalCSV 
                ok=$?
                if [ $ok -eq 1 ]; then
                    errorOut "An Error Occured Parsing the Local User Data CSV; Please Try Again";
                fi ;;
            3) 
                log "Exiting The Program"; 
                exit 1 ;;
            *) 
                echo -e "\f\t>> Error, Please try again <<\n" ;;
        esac 
        x=$(( x+1 ))
        if [ $x -eq 4 ]; then
            log "Input Error Please Try Again Later"
            exit 1
        fi
    done
}
mainMenu