# Git To ClearCase

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
- [ ] Ability to delete files
- [ ] Automatically pull to repo if post-update fails
- [ ] Better logging and output for post-update
- [ ] Error checking for setup.sh
