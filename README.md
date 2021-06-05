# 2021 OS Assignment

**Coded By**: Anthony Legg (leggtc1)
**Last Changes added**: June 4th, 2021
**Note**: *This scripts in this project have been developed to work within a Linux OS environment.*

## **Download and Set-up**

1. Clone the repository to a local directory using the command

   `git clone https://github.com/leggant/2021-OS-Assignment.git`

2. Change the current working directory by entering: `cd 2021-OS-Assignment`

3. Within this directory, you will find the following sub-directories and files:
   - Task-1
     - task1.sh
     - LocalUsers.csv
   - Task-2
     - task2.sh

4. Change the current working directory, enter either: ```cd Task-1``` or ```cd Task-2```

5. Next, set the permission on the `task1.sh` or `task2.sh` files as needed so these have the correct permission to run on your system.
   - `chmod u+x task1.sh`
   - `chmod u+x task2.sh`

6. Lastly, enter: `./task1.sh` or `./task2.sh` from within the `/Task-1` or `/Task-2` sub-folders to run the script.
   - `Task-1` comes with a `LocalUsers.csv` file to be used if the remote download source is offline. If this file is not required, it can be deleted by entering: `rm ./Task-1/LocalUsers.csv`
   - If it is removed, the user can load in a different local file by selecting the second option in the main menu, then entering the full file path when prompted.

## Task 1 - User Administration Script

`task1.sh` will automate the creation and permission configuration of new system users. User configurations are parsed from a `.csv` file that is loaded in from one of three sources selected by the user at runtime.

**Script Location:** `./Task-1/task1.sh`

### Command Line User Input

When the script runs, the user can choose to download the csv from a remote server or use the csv provided in the `Task-1/` directory. The user can input a path to a different file if the `LocalUsers.csv` file is deleted or renamed before running the `task-1.sh` script. To delete `task-1.sh` run the command `rm LocalUsers.csv` and to rename, run `cp LocalUsers.csv newfile.csv`.

Each time the As the script runs, it will output options to the command line which require user input. Incorrect responses will cause the script to request a correct response and will prevent the progression of the script until this is provided. The first time the script runs, it will create a `log.txt` file in the `Task-1` directory. Errors and status information produced by the script will be appended to a new line in this file as well as getting display to the command line. 

After the `.csv` file has been parsed, the user will be advised of the number of new users that will be created on the system and will prompt the user for a final confirmation before continuing. 

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

## Known Bugs

1. The script currently does not have an option provided to allow a user to enter a different URL to download a csv file from. The default URL is hard coded in to the script. 
2. Currently, there is no option provided in the menu that will allow the user to enter a path to an alternative file. The functionality is there, but can only be accessed by renaming or deleting the `LocalUsers.csv` file provided first.
3. The script does not account for users that have parameters missing from the provided `.csv` file. Missing shared folder or group parameters cause an error to be shown in the command line and log file. 
   1. There are no fall back options to handle this currently
   2. The script will continue uninterrupted.

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