#!/bin/bash

list=$(git log --reverse --format="%h" --ancestry-path HEAD^..origin/master | tail -n +2)

while read -r sha; do
    ./clearCommit.sh $sha
done <<< "$list"

