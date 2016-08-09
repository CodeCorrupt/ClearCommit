#!/bin/bash

# Initialize the gir repo
git init
# Add all files in the snapshot
git add -A
# Commit all the files
git commit -m "INIT - Setup Git-To-ClearCase"

# Make the bare repo one level above
name=${PWD##*/}
mkdir "../$name.git" && cd "../$name.git"
git init --bare
# Set up post-update
wget -qP hooks "https://raw.githubusercontent.com/CodeCorrupt/ClearCommit/master/post-update"

# Set up the bare repo as the remote
cd "../$name"
fullpath="$PWD$name.git"
git remote add origin "file://$fullpath"
git push -u origin master

# instruct the user
echo "You're all set, Simply run the following command where you want the project folder"
echo "git clone $fullpath <<your task name>>"
