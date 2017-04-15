## Usage

```
bl add [SUBJECT...]                  # add issues
bl browse KEY                        # browse an issue
bl category SUBCOMMAND ...ARGS       # manage categories
bl close [KEY...]                    # close issues
bl config                            # show config
bl count                             # count issues
bl doctor                            # check issues
bl edit KEY                          # edit issues' description by $EDITOR
bl file SUBCOMMAND ...ARGS           # manage files
bl gitrepo SUBCOMMAND ...ARGS        # show gitrepos
bl groups SUBCOMMAND ...ARGS         #
bl help [COMMAND]                    # Describe available commands or one specific command
bl init                              # initialize a default config file
bl list                              # list issues by typical ways
bl milestone SUBCOMMAND ...ARGS      # manage milestones
bl notifications SUBCOMMAND ...ARGS  #
bl priorities                        # list priorities
bl project SUBCOMMAND ...ARGS        # manage projects
bl recent SUBCOMMAND ...ARGS         # list recent stuff
bl resolutions                       # list resolutions
bl search                            # search issues
bl show KEY                          # show an issue's details
bl space SUBCOMMAND ...ARGS          #
bl statuses                          # list statuses
bl type SUBCOMMAND ...ARGS           # manage types
bl update [KEY...]                   # update issues
bl users SUBCOMMAND ...ARGS          #
bl version                           # show version
bl watchings SUBCOMMAND ...ARGS      #
bl webhooks SUBCOMMAND ...ARGS       #
bl wiki SUBCOMMAND ...ARGS           # manage wikis
```

View global or command specific help:

    bl help
    bl help list
    bl help search
    bl help add

### Issue

List unclosed issues:

    bl list

List overdue issues:

    bl list --overdue

Add an issue:

    bl add "Update OpenSSL immediately" --priorityId 2 --assigneeId 11111 --dueDate 2014-04-07

Add multi issues:

    cat list.txt | xargs -I {} bl add {}

Edit issue by your favorite $EDITOR:

    bl edit ISSUE-12

Update unassigned issues:

    bl list --unassigned | awk '{print $2}' | xargs bl update --assigneeId 12345

### Project

List projects:

    bl project list

Show project progress:

    bl project progress 12345

### Wiki

List wiki pages:

    bl wiki list

Edit wiki page by $EDITOR:

    bl wiki edit 12345

### File

List files:

    bl file list

Download file:

    bl file get 12345
