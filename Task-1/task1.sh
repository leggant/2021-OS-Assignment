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

# ---------------------------------------------------------------------------- #
#          CHECK THE LOCALLY STORED FILE IS BOTH PRESENT AND PARSABLE          #
# ---------------------------------------------------------------------------- #

checkAndParseLocalCSV() {
    echo -e "#### Checking The Default Local User File">>$log;
    checkFile $localfile
    ok=$?
    if [ $ok -eq 0 ]; then
        echo -e "#### $localfile Is Ok To Parse User Data From">>$log
        echo -e "#### $localfile Is Ok To Parse User Data From\n"
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
                    echo -e "\n>>>> Input Error Please Try Again Later";
                    exit 1
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
    echo -e "\n# --------------- Checking If Users File Is Already Downloaded --------------- #"
    checkFile $downloaded
    ok=$?
    if [ $ok -eq 0 ]; then
        #ask user if they want to download fresh data
        echo -e "\n$downloaded Is Already On The Local System\nCSV Contains Content and Is Parsable">>$log;
        echo -e "\n#### $download Is Already Present In The Local File System ####\n#### CSV Contains Content and Is Parsable ####";
        ConfirmUserNumber $downloaded;
    else 
        echo -e "# ---------- No Local Version Of File Found >> Checking Download URL --------- #";
        checkCSV_URI $default 2>>$log;
        URLok=$?
        if [ $URLok -eq 0 ]; then
            echo -e "\n# ------------------- Remote Host/CSV File URL Checked + Ok ------------------ #">>$log;
            echo -e "\n# ---------------- Downloading User Data CSV From Remote Host ---------------- #">>$log;
            echo -e "\n# ------------------- Remote Host/CSV File URL Checked + Ok ------------------ #";
            echo -e "\n# ---------------- Downloading User Data CSV From Remote Host ---------------- #";
            downloadDefaultCSV $default 2>>$log;
            if [ $? -eq 1 ]; then
                echo -e "# -------------------------- File Download Complete -------------------------- #\n">>$log;
                echo -e "# -------------------------- File Download Complete -------------------------- #\n";
                echo -e "# ----------------- Checking Downloaded CSV File is Parsable ----------------- #\n">>$log;
                echo -e "# ----------------- Checking Downloaded CSV File is Parsable ----------------- #\n";
                checkFile $downloaded;
                ok=$?
                if [ $ok -eq 0 ]; then 
                    ConfirmUserNumber $downloaded;
                    if [ $? -eq 0 ]; then
                        parseData $downloaded
                    else
                        # ------------- >>>> An Error Occured, Returning To The Main Menu ------------ #
                        echo -e "\n# ------------- >>>> An Error Occured||Returning To The Main Menu ------------ #\n"
                        echo -e "\n# ------------- >>>> An Error Occured||Returning To The Main Menu ------------ #\n">>$log
                        mainMenu
                    fi
                else
                        # ------------- >>>> An Error Occured, Returning To The Main Menu ------------ #
                        echo -e "\n# ------------- >>>> An Error Occured||Returning To The Main Menu ------------ #\n"
                        echo -e "\n# ------------- >>>> An Error Occured||Returning To The Main Menu ------------ #\n">>$log
                        mainMenu
                fi
            else
                # --------------------- AN ERROR OCCURED DURING DOWNLOAD --------------------- #
                errorOut "\n# --------------------- AN ERROR OCCURED DURING DOWNLOAD --------------------- #\n
                # ------------------------------ Try Again Later ----------------------------- #";
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
        return 0
    else
        return 1
    fi
}

# ---------------------------------------------------------------------------- #
#              DOWNLOAD THE CSV FILE FROM THE DEFAULT URL RESOURSE             #
# ---------------------------------------------------------------------------- #

downloadDefaultCSV() {
    if wget - $default 2>>$log; then
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
    echo -e "#                 The Script Is Now Ready To Create $Num Users                 #"
    echo -e "# ---------------------------------------------------------------------------- #\n"
    while [[ $x -le 3 ]]; do
        read -p "#### Do You Wish to Proceed? " confirm;
        case $confirm in
            Y | Yes | y | yes)
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

# ----------------- If Successful, THen Check & Parse CSV file ---------------- #
# ---------------------------- Parse User CSV File ---------------------------- #

parseData() {
    {
        read -r
        while IFS=";" read -r email dob group shared
        do
            password=$(date -d $dob +'%m%Y')
            echo -e "\nConverting $dob to Password: $password"
            ## Create User Name From Email
            xname=$email
            initial=${xname:0:1}
            last=$(echo "$xname" | cut -d"@" -f1 | cut -d"." -f2)
            name=$initial$last
            echo -e "\nConverted $xname to username: $name"
            ## Check If User Name Exists
            checkIfUserExists $name
            ok=$?
            # user does not exist, create user with all parsed params
            if [ $ok -eq 0 ]; then
                createUser $name $password 
            fi
            # check if group exists will also call a create group function if this group does not exist
            checkIfGroupExists $group
            addUserToGroups $group $name
            ## Creating Shared Folder If It Does Not Exist
            # Remove '/' from shared
            folder=$(echo "$shared" | awk -F/ '{print $NF}')
            # check if folder exists, create if it does not - this function will do both
            checkSharedFolderExists $folder $name
            #create 
            createSharedFolderLink $folder $name
            # Assign user to shared folders
            # create user alias
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
            echo -e "\n>>> Group: $group already exists">>$log;
        else
            echo -e "\n>>> Group: $group does not exist";
            echo -e "\n>>> Group: $group does not exist; Creating $group">>$log;
            createNewGroup $group;
        fi
    done
}

createNewGroup () {
    sudo groupadd $1
    return $?
}

addUserToGroups() {
    sudo usermod -a -G $1 $2;
}

# ---------------------------------------------------------------------------- #
#         CHECK IF A USER CURRENTLY EXISTS, CREATE USER IF THEY DO NOT         #
# ---------------------------------------------------------------------------- #

checkIfUserExists() {
    if id -un $1; then
        echo "$1 already exists"
        return 1;
    else
        echo "$1 does not exist"
        return 0;
    fi
}

createUser() {
    user=$1
    password=$2
    echo -e "Create New User $user";
    sudo useradd -d /home/$user -m -s /bin/bash $user;
    ok=$?
    if [ $ok -eq 0 ]; then
        createUserPassword $user $password
        return $?
    fi
}

createUserPassword() {
    user=$1
    password=$2
    sudo passwd -e $password $user;
    return $?
}

checkSharedFolderExists() {
if [ -n "$1" ]; then
	echo "$1 exists"
else
	createSharedFolder $1
fi    
}

createSharedFolder() {
    dir=$1
    sudo mkdir -p /home/$dir
    sudo chmod 770 /home/$dir
    sudo chown : root /home/$dir
}
# For each user with permission to a shared folder, create a link in the users home folder to the shared directory. Link name: 'shared'
createSharedFolderLink() {
    ln -s $1 /home/$2/sharedfolder
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
mainMenu() {
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
                if [ $ok -eq 1 ]; then
                    errorOut "An Error Occured Parsing the Local User Data CSV; Please Try Again";
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
mainMenu
