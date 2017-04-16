## Usage

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

### Milestone

Add an milestone:

    bl milestone add m1 --releaseDueDate=2017-04-01


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
