# Git To ClearCase

## Data Flow Diagram
```
.                     ClearCase (CC) Snapshot
                 +-----------------------------------+
MyWorking        | Repo.git               CC Working |                CC Remote
######    push   |  ###### CC pull triggers ######   |  push after git   ######
###### <----------> ###### ---------------> ###### --|-----------------> ######
######    pull   |  ###### <--------------- ###### <-|------------------ ######
                 |      pull if trigger fails        |  Pull w/ git push   ^
                 +-----------------------------------+                     |
                                                                           |
        Dumb CC User                                                       |
            ######         push and pull using CC tools                    |
            ###### <-------------------------------------------------------+
            ######
```

## Steps for Git users
```
1) Work in yuour working dir.
2) Push to Repo.git
3) push to repo triggers CC Working to pull in the new changes
4) that trigger first pulls anything new from CC remote
5v1) If anything new came in from CC Remote, fail push
6v1) Repo.git pulls in the new changes that are in CC Working
5v2) If nothing new came if from CC Remote, merge changes from git
6v2) commit changes in CC working/sync to cc remote
```

## Steps for CC users
```
1) Nothing changes
```

## TODO:
- [x] Ability to modify files
- [x] Ability to add new files
- [ ] Ability to delete files
- [ ] Automatically pull to repo if post-update fails
- [ ] Better logging and output for post-update
- [ ] Error checking for setup.sh
