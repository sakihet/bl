# bl

bl is a command line tool for Nulab's [Backlog](http://www.backlog.jp/).

[![Gem Version](https://badge.fury.io/rb/bl.svg)](https://badge.fury.io/rb/bl)
![License](https://img.shields.io/github/license/sakihet/bl.svg)

## Table of Contents
- [Requirements](https://github.com/sakihet/bl#requirements)
- [Installation](https://github.com/sakihet/bl#installation)
- [Configuration](https://github.com/sakihet/bl#configuration)
- [Help](https://github.com/sakihet/bl#help)
- [Usage](https://github.com/sakihet/bl#usage)
- [Contributing](https://github.com/sakihet/bl#contributing)
- [License](https://github.com/sakihet/bl#license)

## Requirements

- ruby 2.3+

## Installation

    gem install bl

## Configuration

bl uses `~/.bl.yml` for configuration.

```
bl init
$EDITOR ~/.bl.yml
```

### .bl.yml Parameters

```
:space_id: '***'    # your backlog space id
:api_key: '***'     # your backlog api key
:project_key: '***' # your backlog project key
:issue:
  :default:         # issue default parameters(add command use this for easiness)
    :projectId:
    :issueTypeId:
    :priorityId:
    :assigneeId:
```

## Help

```
Commands:
  bl add [SUBJECT...]                 # add issues
  bl browse KEY                       # browse an issue
  bl category SUBCOMMAND ...ARGS      # manage categories
  bl close [KEY...]                   # close issues
  bl config                           # show config
  bl count                            # count issues
  bl edit KEY                         # edit issues' description by $EDITOR
  bl file SUBCOMMAND ...ARGS          # manage files
  bl gitrepo SUBCOMMAND ...ARGS       # show gitrepos
  bl group SUBCOMMAND ...ARGS         # manage groups
  bl help [COMMAND]                   # Describe available commands or one specific command
  bl init                             # initialize a default config file
  bl list                             # list issues by typical ways
  bl milestone SUBCOMMAND ...ARGS     # manage milestones
  bl notification SUBCOMMAND ...ARGS  # manage notifications
  bl priorities                       # list priorities
  bl project SUBCOMMAND ...ARGS       # manage projects
  bl pullrequest SUBCOMMAND ...ARGS   # manage pull requests
  bl recent SUBCOMMAND ...ARGS        # list recent stuff
  bl resolutions                      # list resolutions
  bl roles                            # list roles
  bl search                           # search issues
  bl show KEY                         # show an issue's details
  bl space SUBCOMMAND ...ARGS         # manage space
  bl statuses                         # list statuses
  bl type SUBCOMMAND ...ARGS          # manage types
  bl update [KEY...]                  # update issues
  bl user SUBCOMMAND ...ARGS          # manage users
  bl version                          # show version
  bl watching SUBCOMMAND ...ARGS      # manage watchings
  bl webhook SUBCOMMAND ...ARGS       # manage webhooks
  bl wiki SUBCOMMAND ...ARGS          # manage wikis

Options:
  [--format=FORMAT]  # set output format
                     # Default: table

```

View global or command specific help:

```
bl help
bl help list
bl help search
bl help add
```

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sakihet/bl.

## License

[MIT](http://opensource.org/licenses/MIT).

