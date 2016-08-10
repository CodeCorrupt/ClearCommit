# Git To ClearCase

## Setup
1. Create a snapshot view with ClearCase
2. `cd /path/to/snapshot`
3. `curl https://raw.githubusercontent.com/CodeCorrupt/Git-To-ClearCase/master/setup.sh | /bin/bash`
4. `cd /path/to/working/directory`
5. `git clone file:///path/to/snapshot.git project-name`
6. Be happy using git :smile:

## Data Flow Diagram
```
.                     ClearCase (CC) Snapshot
                 +-----------------------------------+
Git Working      |  CC.git                CC Working |                CC Remote
######    push   |  ###### CC pull triggers ######   |  push after git   ######
###### <----------> ###### ---------------> ###### --|-----------------> ######
######    pull   |  ###### <--------------- ###### <-|------------------ ######
                 |      pull if trigger fails        |  Pull w/ git push   ^
                 +-----------------------------------+                     |
                                                                           |
         Dumb CC User                                                      |
            ######             push and pull using CC tools                |
            ###### <-------------------------------------------------------+
            ######
```
_Note: CC.git is view-private_

## Steps for Git users
```
1) Work in your working directory as normal
2) push and pull with co-workers
3) When ready to commit to ClearCase, push to CC.git
```

## Steps for CC users
```
1) Nothing changes
```

## TODO:
- [x] Ability to modify files
- [x] Ability to add new files
- [x] Ability to delete files
- [ ] Option to remove empty directory after file delete
- [ ] ~~Automatically pull new changes into CC.git from CC Working after `cleartool update .` in post-update~~
- [ ] Pull updates from CC remote, thorugh CC Working into CC.git on pre-update
- [ ] Decide if I should remove the prompt for add and delete? (Assume Yes)
- [ ] Better logging and output for post-update
- [ ] Error checking for setup.sh
