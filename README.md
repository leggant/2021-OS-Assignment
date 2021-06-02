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

`task1.sh` will automate the creation and permission configuration of new system users. User configurations are parsed from a `.csv` file that is loaded in from one of three sources selected by the user at runtime.

**Script Location:** `./Task-1/task1.sh`   

## User Input Options



## Script Output (Example)

**Example Input User Data Provided In a .csv File:**

```bash
edsger.dijkstra@tue.nl;1930/05/11;sudo;/sharedUsers
```

**Example User Configuration:** 

- **User Name**: edijkstra
- **Temporary User Password:** 051930 *Password must be changed by the user when they log on for the first time*
- **Secondary Group Assignment:** sudo
- **Shared Folder Access:** `/home/sharedUsers`
- **Link To Shared Folder From Users Directory:** `/home/edijkstra/shared`

### Error Handling



### Known Bugs





# Task 2 - Directory Compression and Transfer

## Overview

**Script Location:** `./Task-2/task2.sh`

**Directory:**

**User Input Options:**

**Error Handling:** 

**Expected Results:**



# Known 



### Task 1



### Task 2

