# OS Assignment Tasks

#### Assignment Due Date: Monday, 31 May 2021

---

1. **Task 1:** Author a script to automate the creation of users and configuration of the user
   environment (60%)
2. **Task 2:** Author a script to backup directories and upload the backup to a remote server
   (20%)
3. **Formal Aspects:** Error handling, documentation, commenting, code modularity and git
   usage (20%)  

## Task 1 – Creating a User Environment (60%)

Write a script that **automates the process of user creation**, followed by **configuration of the user environment on a Ubuntu Linux system**. The script will ingest a file containing user-related information, and should create users based on the information in the provided file. Additionally, the script should perform a basic configuration of the user environment including creation of secondary groups, shared folders and setting of permissions.  

#### Bash Script Core Functionality Check List

- [ ] script should ingest a CSV file (local or remote) that contains user information
- [ ] Create each specified user while implementing best practices
- [ ] Set a default password for the user based on the user’s birth date
- [ ] Create the required secondary groups (if specified and non-existent)
- [ ] Assignment to the correct secondary groups (if specified)
- [ ] Create the required shared folder (if specified and non-existent)
- [ ] Create the required secondary group for the shared folder (if specified and non-existent)
- [ ] Assignment of the user to a group to access the shared folder (if specified)
- [ ] Creation of a link to the users shared folder (if specified)
- [ ] Creation of an alias to shutdown the system (if user is in the sudo group)
- [ ] Enforce a password change at first login  

### Script Input File Requirements

script should be able to handle the following inputs incl. support for two different command line arguments

1. Support for two different command line arguments, either:
   (a) **A URI for a web-based resource**
   (b) A local file system location
2. Support for two different user inputs when no command line argument have been supplied, either:
   (a) **A URI for a web-based resource**
   (b) A local file system location  

1. When a file has been provided in the local file system, it should
   - be checked for existence
   - that it is actually a parse-able file. 
2. If a file is provided by a URI, the script should
   - [ ] download the file (to the same directory as the script),
   - [ ] check file existence, 
   - [ ] that it is parse-able and then
   - [ ] proceed with processing.

Once the input file is ingested, the script should parse the file and use it to create users and
configure the environment on the local system. One sample file has been provided as an example
of the structure of the input file format. 

```bash
e-mail;birth date;groups;sharedFolder
edsger.dijkstra@tue.nl;1930/05/11;sudo,staff;/staffData
john.mccarthy@caltech.edu;1927/09/04;sudo,visitor;/visitorData
andrew.tanenbaum@vua.nl;1944/03/16;staff;/staffData
alan.turing@cam.ac.uk;1912/06/23;visitor;/visitorData
linus.torvalds@linux.org;1969/12/28;sudo;
bjarne.stroustroup@tamu.edu;1950/12/30;;/visitorData
ken.thompson@google.com;1973/02/04;sudo,visitor;
james.gosling@sun.com;1955/05/19;staff;/staffData
tim.berners-lee@mit.edu;1955/06/08;sudo,visitor;/visitorData
```

Each row of the sample file represents an individual user. The sample file contains a header that documents each column in the file. The available columns in the file are:

- The email address of the user
- The birth date of the user (in the format YYYY/MM/DD, for example, 1991/11/17)
- The secondary groups the user should be added to
- A shared folder that the user requires full access to (full rwx permissions)  

### User Environment Requirements

#### Username

1. The username is generated from the provided e-mail address. 
2. The username structure must adhere to the following conventions: 
   - [ ] The first letter of the first name, followed by the entire surname. 
   - [ ] the following email: **linus.torvalds@linux.org**, the username would be: **ltorvalds**.
   - [ ]  If a given username already exists, the script should ignore the user entry in the file (i.e. not create the user) and provide console notification about this event.

#### Password

1. The password is to be generated from the birth date. 

The default password for the user should be the month and year of the users birth date appended together in the following format: MMYYYY. For example, if a user Linus Torvalds has the birth date 1969/12/28, his default password should be 121969. Check the date command on how extract date components. The user should also be asked to change his/her password upon first login. For this purpose have a look at the chage command. Shared Folder: The shared folder should be created (if not yet existing) and permissions adjusted accordingly. The shared folder paths should be treated as absolute paths. To maintain the permission set for existing users to the shared folder (not just the last added user), you will need to think about how to use additional groups (beyond the ones specified in the users file) to achieve this. The owning user of the shared folder should either be root or the user who is running the script. Note: users in the other group should have no access to shared folders. Share Folder Link: For each user with any permission to a shared directory, place a link within the user’s home folder to the shared directory. The link should be named shared and point to
the shared folder the user has access to.



Alias: For each user with sudo access, create an alias named off that shuts down the system
(using the command: systemctl poweroff). The alias should be stored in the correct file so
that it is loaded upon every login to ensure the alias is available to the user.
Best Practice: It is essential that you implement best practices for user, group, shared folder,
link and alias creation and configuration. We have discussed this in class. For example, some
best practice for user creation are home directory naming convention and default shell settings.
For example, the best practice for alias creation are using the .bash_alias file for storing
aliases.  