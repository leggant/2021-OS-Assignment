# 2021 OS Assignment

**Coded By**: Anthony Legg (leggtc1)
**Last Changes added**: June 4th, 2021
**Note**: *This scripts in this project have been developed to work within a Linux OS environment.*

## **Download and Set-up**

1. Clone the repository to a local directory using the command `git clone https://github.com/leggant/2021-OS-Assignment.git`
2. Change the current working directory by entering: `cd 2021-OS-Assignment`
3. Within this directory, you will find the following sub-directories and files:
   - Task-1
     - task1.sh
     - LocalUsers.csv
   - Task-2
     - task2.sh
4. Change the current working directory, enter either: `cd Task-1` or `cd Task-2`
5. Next, set the permission on the `task1.sh` or `task2.sh` files as needed so these have the correct permission to run on your system.
   1. `chmod u+x task1.sh`
   2. `chmod u+x task2.sh`
6. Lastly, enter: `./task1.sh` or `./task2.sh` from within the `/Task-1` or `/Task-2` sub-folders to run the script.
   1. `Task-1` comes with a `LocalUsers.csv` file to be used if the remote download source is offline. If this file is not required, it can be deleted by entering: `rm ./Task-1/LocalUsers.csv` 
   2. If it is removed, the user can load in a different local file by selecting the second option in the main menu, then entering the full file path when prompted. 

# Task 1 - User Administration Script

## Overview

`task1.sh` will automate the creation and permission configuration of new system users. User configurations are parsed from a `.csv` file that is loaded in from one of three sources: *1 - downloaded from remote server, local file provided with the repository*

*in one of three ways, downloading from a remote server, from a local file that is downloaded with the repository or, if this* This script will automate the creation and administration of new system users. User information is downloaded from GitHub then parsed by into the script from an external .csv file.  assignment to user groups,

**Directory**: `./Task-1/task1.sh` 

### **User Input Options:** 



### **Error Handling:**



• The email address of the user
• The birth date of the user (in the format YYYY/MM/DD, for example, 1991/11/17)
• The secondary groups the user should be added to
• A shared folder that the user requires full access to (full rwx permissions)

# Task 2 - Directory Compression and Transfer

**Purpose:** 

**Directory:**

**User Input Options:**

**Error Handling:** 

**Expected Results:**



