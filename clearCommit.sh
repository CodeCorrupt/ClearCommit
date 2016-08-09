#!/bin/bash

# For this script to work you must satisfy the following conditions
#  1) Working directory must be clean
#  2) master to the specefied merge MUST be fast forward
#  3) spefecied branch must be a child of master

# Thoughts:
#   Have system individually check out files from git as needed
#     Then after clearcase is up to date, force merge by moving branch pointer
#   On Add, durring checkin, if it's a new directory add directorys
#   On Del, durring checkin, if there are no more files in directory remove.
#     This may cause problems if you want to keep the folder, but I'm following
#     git's established way of not tracking empty repos

echo "start"

#check that you supplied a commit ID
if [ -z "$1" ]
then
    echo "Need to supply a commit id"
    exit
fi

#Check working directory is clean
if [ $(git status --porcelain 2>/dev/null| grep "^[^?]" | wc -l) -ne 0 ]
then
    echo "Working directory not clean"
    exit
fi

echo "###################"
echo "Starting the setup and checkout"
echo "###################"

#Show list of files and status
# Get the list of files that changed
files=$(git diff --name-status HEAD $1)
comment=$(git log --reverse --format=%B $1 ^HEAD)
# Checkout all the files from Clearcase
while read -r status name; do
    echo "$status : $name"
    if [ $status == "M" ]; then
        echo "Modefied file: $name"
        cleartool checkout -c "$comment" "$name"
    fi
    if [ $status == "D" ]; then
        echo "Deleted file: $name"
	#Checkout the parent directory
	if [ $(cleartool describe $(dirname "$name") | grep -e '^\s*checked out' | wc -l) -eq 0 ]; then
	    cleartool checkout -c "$comment" $(dirname "$name")
	fi
    fi
    if [ $status == "A" ]; then
        echo "Added file: $name"
	#Checkout the parent directory
	if [ $(cleartool describe $(dirname "$name") | grep -e '^\s*checked out' | wc -l) -eq 0 ]; then
	    cleartool checkout -c "$comment" $(dirname "$name")
	fi
    fi
    echo ""
done <<< "$files"

echo "###################"
echo "Starting the git merge"
echo "###################"

#Checkout the commit with git
git merge $1


echo "###################"
echo "Starting the save"
echo "###################"
# Checkin all the files to Clearcase
while read -r status name; do
    if [ $status == "M" ]; then
        echo "Modefied file: $name"
        cleartool checkin -c "$comment" "$name"
    fi
    if [ $status == "D" ]; then
        echo "Deleting file: $name"
        cleartool rmname -c "$comment" "$name"
    fi
    if [ $status == "A" ]; then
        echo "Added file: $name"
        cleartool mkelem -c "$comment" "$name"
        cleartool checkin -c "$comment" "$name"
    fi
    echo ""
    echo "Checking in $file"
done <<< "$files"

#Check in the directories that were checked out for A and D
while read -r status name; do
    if [ $status == "D" ] || [ $status == "A" ]; then
	if [ $(cleartool describe $(dirname "$name") | grep -e '^\s*checked out' | wc -l) -ge 1 ]; then
            cleartool checkin -c "$comment" $(dirname "$name")
	fi
    fi
done <<< "$files"
