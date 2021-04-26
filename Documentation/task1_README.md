# 3.1 Core Functionality
The core functionality required in your Bash script is listed below:
• The script should ingest a CSV file (local or remote) that contains user information, which
contains the values required to perform the following tasks:
• Create each specified user while implementing best practices
• Set a default password for the user based on the user’s birth date
• Create the required secondary groups (if specified and non-existent)
• Assignment to the correct secondary groups (if specified)
• Create the required shared folder (if specified and non-existent)
• Create the required secondary group for the shared folder (if specified and non-existent)
• Assignment of the user to a group to access the shared folder (if specified)
• Creation of a link to the users shared folder (if specified)
• Creation of an alias to shutdown the system (if user is in the sudo group)
• Enforce a password change at first login
# 3.1.2 User Environment Requirements
Username: The username is to be generated from the provided e-mail address. The username
structure must adhere to the following conventions: The first letter of the first name, followed by
the entire surname. For example, if a user had the following email: linus.torvalds@linux.org,
the username would be: ltorvalds. If a given username already exists, the script should ignore the user entry in the file (i.e. not create the user) and provide console notification about
this event.
Password: The password is to be generated from the birth date. The default password for the
user should be the month and year of the users birth date appended together in the following
format: MMYYYY. For example, if a user Linus Torvalds has the birth date 1969/12/28, his default
password should be 121969. Check the date command on how extract date components. The
user should also be asked to change his/her password upon first login. For this purpose have a
look at the chage command.
Shared Folder: The shared folder should be created (if not yet existing) and permissions adjusted accordingly. The shared folder paths should be treated as absolute paths. To maintain
the permission set for existing users to the shared folder (not just the last added user), you will
need to think about how to use additional groups (beyond the ones specified in the users file)
to achieve this. The owning user of the shared folder should either be root or the user who is
running the script. Note: users in the other group should have no access to shared folders.
Share Folder Link: For each user with any permission to a shared directory, place a link within
the user’s home folder to the shared directory. The link should be named shared and point to
the shared folder the user has access to.

Alias: For each user with sudo access, create an alias named off that shuts down the system
(using the command: systemctl poweroff). The alias should be stored in the correct file so
that it is loaded upon every login to ensure the alias is available to the user.
Best Practice: It is essential that you implement best practices for user, group, shared folder,
link and alias creation and configuration. We have discussed this in class. For example, some
best practice for user creation are home directory naming convention and default shell settings.
For example, the best practice for alias creation are using the .bash_alias file for storing
aliases.
# 3.1.3 Script Output and Logging
Script Output: Your script should provide console output (stdout) for major events. This is
to provide the user with information about what actions the script is performing. The following
list provides a summary of the required output:
• Print information about the input file
• Print a dialog about the number of users to be added
• For each user, print a summary of the created user environment including (but not limited
to): username, home directory, shared folder, shared folder link, alias
• Print information when a major error is encountered, including (but not limited to): user
creation failed, shared folder creation failed, group creation failed, alias creation failed,
link creation failed
Before the script starts creating users and setting up the user environment, it should present the
user a dialogue that informs about the number of to-be-added users and asks for confirmation
before proceeding. Try not to use too much console-based output, if it is too cluttered the user
will not be able to easily track what is happening. Also, formatting console-based output using
line breaks or indentation can greatly increase readability.
Logging Output: Your script should also provide functionality to output additional detailed
information to a log file. This log file should be much more detailed than the console output, and
should keep track of the success/failure of user creation and success/failure of user environment
configuration. This is specified so that the user can review the log file to determine where
anything went wrong when running the script. This log file should include date information
that indicates when the script was run. Make sure you also choose a sensible name for the log
file.
# 3.2 Script Error Checking
Your script should check for all possible errors and deal with them by presenting the user with
information and also logging it. Carefully think about things that can possibly go wrong or
cause problems during script execution. Acknowledge possible problems in the script, even if
you do not address them – that way your tutor knows you have identified the error, but have not
fixed it.

# 3.3 Code Structure and Best Practice
**Code Structure:** Structure your code by moving repetitive code into functions. When implementing functions, use local variables where possible to avoid eventual side effects of global variable usage.

**Code Comments:** Provide sensible documentation through comments. Sensible implies that you don’t necessarily comment each line of code, but comment critical or complex operations that might be difficult for another user to understand quickly when reviewing your code. This
way the reader should get quick insight about what happens where in your code.

## 3.4 Hints
The following hints may provide useful during development of your script:
1. Start with a basic script that reads the input URI and local file
2. Start by using print statements instead of actual commands
3. Create a dummy user input file that only contains one user for testing
4. Test added code thoroughly before adding any additional functionality
5. Create a clean-up script that removes users, groups and shared folders so that you can quickly reset your system back to default to ease the testing process
6. If you don’t manage to get all parts of the code working, annotate sections that are missing code or functionality and describe what should have happened there
7. Continually save code changes using git (discussed later)