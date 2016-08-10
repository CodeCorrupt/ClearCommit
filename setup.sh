#!/bin/bash

# Constants
GITTOCC=".gittocc"

# Initialize the gir repo
git init
# Add .gittocc to .gitignore
echo "$GITTOCC" >> .gitignore
# Add all files in the snapshot
git add -A
# Commit all the files
git commit -m "INIT - Setup Git-To-ClearCase"

# Make the bare repo at ./.gittocc
mkdir "./$GITTOCC" && cd "./$GITTOCC"
git init --bare

# Set up the bare repo as the remote
cd ".."
git remote add origin "file://$PWD/$GITTOCC"
git push -u origin master

# Set up post-receive
wget -qP "$PWD/$GITTOCC/hooks" "https://raw.githubusercontent.com/CodeCorrupt/Git-To-ClearCase/master/post-receive"
wget -qP "$PWD/$GITTOCC/hooks" "https://raw.githubusercontent.com/CodeCorrupt/Git-To-ClearCase/master/pre-receive"

# instruct the user
echo ""
echo ""
echo ""
echo "******************************************************"
echo "*************   All Done! :D   ***********************"
echo "******************************************************"
echo "You're all set, Simply run the following command where you want the project folder"
echo "git clone $PWD/$GITTOCC <<your task name>>"
