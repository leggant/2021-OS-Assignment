
# Check if Group Exists, Create If Not Exists

checkGroup() {
a=$1
b=$2
echo "$a & $b"
}
checkGroup "Text1" "text2"

# function_checkIfFileExists() {
#     if [ -f "$FILE" ]; then
#         echo -e "$FILE exists.\n\n" 
#         cat $FILE
#     else 
#         echo "$FILE does not exist."
#         echo "Please enter a new FILE path/url: "
#     fi
# }

# function_checkIfFILEIsParsable() {
#     if [[ -x "$FILE" ]]
#     then
#         echo "FILE '$FILE' is executable"
#         return true
#     else
#         echo "FILE '$FILE' is not executable or found"
#         return false
#     fi
# }

# checkIfFileExists()

#chmod u+x $FILE
#ls -al | grep $FILE