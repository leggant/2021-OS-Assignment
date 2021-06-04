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
   - `chmod u+x task1.sh`
   - `chmod u+x task2.sh`
6. Lastly, enter: `./task1.sh` or `./task2.sh` from within the `/Task-1` or `/Task-2` sub-folders to run the script.
   - `Task-1` comes with a `LocalUsers.csv` file to be used if the remote download source is offline. If this file is not required, it can be deleted by entering: `rm ./Task-1/LocalUsers.csv`
   - If it is removed, the user can load in a different local file by selecting the second option in the main menu, then entering the full file path when prompted.

## Task 1 - User Administration Script

`task1.sh` will automate the creation and permission configuration of new system users. User configurations are parsed from a `.csv` file that is loaded in from one of three sources selected by the user at runtime.

**Script Location:** `./Task-1/task1.sh`

### User Input Options

When the script runs, the user can choose to download the csv from a remote server or use the csv provided in the `Task-1/` directory. The user can input a path to a different file if the command `rm LocalUsers.csv` before running the `task-1.sh` script.

Before creating the new users, the script will confirm the number of users the will be created and will prompt the user to confirm they want to proceed.  As the script runs, it will output its current state to the console and will copy output to a `log.txt` file that is generated in the

### Script Input/Output (Example)

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

## Task 2 - Directory Compression and Transfer

**Script Location:** `./Task-2/task2.sh`

**Directory:**

**User Input Options:**

**Error Handling:**

**Expected Results:**

### Task 2 Bugs

#### What to do if an error occurs

When writing your README file, think about the reader as someone who does not know the
instructions provided in this document. Make sure to write the documentation for someone
who has limited knowledge of the Linux operating system. Additionally, think of yourself half
a year down the road, and what documentation you will need to understand the scripts you have
authored, how to run them, and what their purposes are.

NOTE: The other components of the formal aspects of this assignment (including error handling, code commenting and code modularity) are all assessed during review of your scripts for Task 1 and Task 2.
