# 2021 OS Assignment

**Coded By**: Anthony Legg (leggtc1)
**Last Changes added**: June 4th, 2021
**Note**: *This scripts in this project have been developed to work within a Linux OS environment.*

## **Download and Set-up**

1. Clone the repository to a local directory using the command

   ```bash
   git clone https://github.com/leggant/2021-OS-Assignment.git
   ```

2. Change the current working directory by entering: 

   ```bash
   cd 2021-OS-Assignment
   ```

3. Within this directory, you will find the following sub-directories and files:
   - Task-1
     - task1.sh
     - LocalUsers.csv
   - Task-2
     - task2.sh

4. Change the current working directory, enter either: 

   ```bash
   cd Task-1
   ```

   ```bash
   cd Task-2
   ```

5. Next, set the permission on the `task1.sh` or `task2.sh` files as needed so these have the correct permission to run on your system.

   ```bash
   chmod u+x task1.sh
   ```

   ```bash
   chmod u+x task2.sh
   ```

6. Lastly, enter: `./task1.sh` or `./task2.sh` from within the `/Task-1` or `/Task-2` sub-folders to run the script.
   - `Task-1` comes with a `LocalUsers.csv` file to be used if the remote download source is offline. If this file is not required, it can be deleted by entering:

     ```bash
     rm ./Task-1/LocalUsers.csv
     ```

   - If it is removed, the user can load in a different local file by selecting the second option in the main menu, then entering the full file path when prompted.

## Task 1 - User Administration Script

`task1.sh` will automate the creation and permission configuration of new system users. User configurations are parsed from a `.csv` file that is loaded in from one of three sources selected by the user at runtime.

**Script Location:** `./Task-1/task1.sh`

### Command Line User Input

When the script runs, the user can choose to download the csv from a remote server or use the csv provided in the `Task-1/` directory. The user can input a path to a different file if the `LocalUsers.csv` file is deleted or renamed before running the `task-1.sh` script. To delete `task-1.sh` run the command `rm LocalUsers.csv` and to rename, run `cp LocalUsers.csv newfile.csv`.

Each time the As the script runs, it will output options to the command line which require user input. Incorrect responses will cause the script to request a correct response and will prevent the progression of the script until this is provided. The first time the script runs, it will create a `log.txt` file in the `Task-1` directory. Errors and status information produced by the script will be appended to a new line in this file as well as getting display to the command line. 

After the `.csv` file has been parsed, the user will be advised of the number of new users that will be created on the system and will prompt the user for a final confirmation before continuing. 

### Example Script Input & Output

**Example Input User Data Provided In a .csv File:**

```
edsger.dijkstra@tue.nl;1930/05/11;sudo;/sharedUsers
```

**Example User Configuration:**

- **User Name**: edijkstra
- **Temporary User Password:** 051930 *Password must be changed by the user when they log on for the first time*
- **Secondary Group Assignment:** sudo
- **Shared Folder Access:** `/home/sharedUsers`
- **Link To Shared Folder From Users Directory:** `/home/edijkstra/shared`

### Known Bugs

1. The script currently does not have an option provided to allow a user to enter a different URL to download a csv file from. The default URL is hard coded in to the script. 
2. Currently, there is no option provided in the menu that will allow the user to enter a path to an alternative file. The functionality is there, but can only be accessed by renaming or deleting the `LocalUsers.csv` file provided first.
3. The script does not account for users that have parameters missing from the provided `.csv` file. Missing shared folder or group parameters cause an error to be shown in the command line and log file. 
   1. There are no fall back options to handle this currently
   2. The script will continue uninterrupted.

## Task 2 - Directory Compression and Transfer

`task2.sh` will compress a local directory selected by the user into a tar file using gunzip compression. Once created, the user will be prompted to enter the details of a remote host to transfer the compressed files to. After asking the user to confirm the information provided, the script will start a secure session with the remote host; the user will be prompted to enter the remote host password. Once the remote host accepts password, the script will securely copy the compressed file to the directory entered by the user.

Upon completion, the script will output confirmation of the successful transfer and will log a successful result to the `log.txt` file.

**Script Location:** `./Task-2/task2.sh`

### Error Handling

The user is asked to confirm the information they provide each time they enter information to the command line. they provide in the command line. Each question has a maximum of 4 incorrect entries before the script outputs an error. 

If the user does not enter a destination path they will continue to be prompted to enter this before the script will proceed to the next stage. When all inputs have been received the user is prompted to confirm they want to proceed with the transfer to the destination directory on the remote host  using the username and IP address information provided. At this point the user can opt to exit and re-enter the information if needed. 

### Known Bugs

Script does not have any function to check that the destination device has the directory path entered by the user or if the remote host is online/available to accept the transfer.

The IP function currently does not check if the user does not enter a required value when asked for a IP address or username.