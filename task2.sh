
#run a loop
for i in {1..10} ;do
    echo $i
done
set +x
for i in {a..z} ;do
    echo $i
done

#echo text 
echo "this is a test script"

DATE=$(date)
echo $DATE

#git fetch to get the data



# Make make intermediary directories
#mkdir -p parent/child/grandchild

#output results to a text file.
#bash TutorialSeries/chapter1.sh 2> debug.txt