# Git To ClearCase

## Setup
1. Create a snapshot view with ClearCase
2. open a Bash prompt that has git.
3. `cd /path/to/snapshot`
4. `curl https://raw.githubusercontent.com/CodeCorrupt/Git-To-ClearCase/master/setup.sh | /bin/bash`
5. `cd /path/to/working/directory`
6. `git clone file:///path/to/snapshot/.gittocc project-name`
7. Be happy using git :smile:

## How It Works
GTCC at it's core is a work-flow using Git's hook system to manage the bridge between Git and CC. This approach to creating a bridge enables both CC and Git users to work how they are most comfortable while still keeping the two repositories in sync.

## Data Flow Diagram
```
.                        ClearCase (CC) Snapshot
                 +-----------------------------------+
Git Working      |  CC.git                CC Working |                CC Remote
######    push   |  ###### on post-receive  ######   |  push after git   ######
###### <----------> ###### ---------------> ###### --|-----------------> ######
######    pull   |  ###### <--------------- ###### <-|------------------ ######
                 |    on changes w/ pre-receive      |  on pre-receive     ^
                 +-----------------------------------+                     |
                                                                           |
            CC User                                                        |
            ######             push and pull using CC tools                |
            ###### <-------------------------------------------------------+
            ######
```

### Data Flow Triggers
* Push Git Working to CC.git
  * Pre-receive triggers _before_ any changes are made to CC.git
    * Pulls changes (if any) from CC Remote into CC Working.
    * If there were changes, push from CC Working to CC.git and **reject push** from Git Working
    * If no changes then **Accept push** from Git Working
  * Post-receive triggers _after_ refs are updated in CC.git
    * Pull changes into CC Working from CC.git
    * Commit the changes to CC (Push from CC Working to CC Remote)
      * *Add/Delete*: Triggered by parsing `git diff --name-status prev_sha HEAD`
      * *Renamed*: Same as Add/Delete. git reports the diff as an Add and a Delete.
      * *Modified*: Triggered by asking CC what files have been "Hijacked".

## Steps for Git users
1. Work in your working directory as normal
2. push and pull with co-workers
3. When ready to commit to ClearCase, push to CC.git

## Steps for CC users
1. Nothing changes
2. Carry on

## TODO:
- [x] Ability to modify files
- [x] Ability to add new files
- [x] Ability to delete files
- [ ] Option to remove empty directory after file delete
- [ ] Exit post-receive early if nothing to push to CC. (ie. when pushing changes coming in from CC Remote)
- [x] Pull updates from CC remote, thorugh CC Working into CC.git on pre-update
- [x] Make post-receive CC check in the parent dir of CC working as well
- [ ] Better logging and output for pre/post-receive
- [ ] Error checking for setup.sh
- [ ] Error handling if someone has checkout/reserved file in CC. (Errors on "Checking out hijacked files") Running the post-receive hook again once other users has checked the file in finish the job.

## To Think About
* Should I remove the prompt for add and delete? (Assume Yes)
* Add .gitignore to CC if created during setup? Prompt and ask?
* For initial setup, all files not already in CC won't be added ever. Similarly, Any empty folders won't be cleaned up. This is because the status change in `git diff --name-status` is the only thing that triggers adding or deleting with CC. Updates to files not tracked in CC will still propagate to CC Working thought git. _Note: modification is triggered through hijacking files and renaming is just addition and deletion_
* pre-receive is pushing to itself, which should be okay for now, but may lead to interesting bugs down the road with it getting stuck in a loop.

## Where It's Going
#### Support for Branching in CC
```
.                                     CC Branch B
                                        ######     
                      +---------------->######<----------------------------+
                      |                 ######      CC Branch C            |
                      |+----------------------------->######<-------------+|
                      ||                              ######              ||
                      VV                              ######              VV
Git Working         CC.git                CC Branch A                 CC Remote
######    push      ######  post-update A   ######      push after git   ######
###### <----------> ###### ---------------> ###### -- -----------------> ######
######    pull      ###### <--------------- ###### <- ------------------ ######
                      on changes w/ pre-update A        on pre-upate A     ^
                                                                           |
            CC User                                                        |
            ######             push and pull using CC tools                |
            ###### <-------------------------------------------------------+
            ######
```
