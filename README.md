# bl

bl is a command line tool for [Backlog](http://www.backlog.jp/).

## Installation

    gem install bl

## Configuration

bl uses `~/.bl.yml` for configuration.

    bl init
    $EDITOR ~/.bl.yml

### .bl.yml Parameters

    :space_id: '***'    # your backlog space id
    :api_key: '***'     # your backlog api key
    :project_key: '***' # your backlog project key

## Usage

    bl activities                    # list activities
    bl add [SUBJECT...]              # add issues
    bl browse KEY                    # browse an issue
    bl category SUBCOMMAND ...ARGS   # manage categories
    bl close [KEY...]                # close issues
    bl config                        # show config
    bl count                         # count issues
    bl help [COMMAND]                # Describe available commands or one specific command
    bl init                          # initialize a default config file
    bl list                          # list issues
    bl milestone SUBCOMMAND ...ARGS  # manage milestones
    bl priorities                    # list priorities
    bl project SUBCOMMAND ...ARGS    # manage projects
    bl resolutions                   # list resolutions
    bl search                        # search issues
    bl show KEY                      # show an issue's details
    bl statuses                      # list statuses
    bl type SUBCOMMAND ...ARGS       # manage types
    bl update [KEY...]               # update issues
    bl users                         # list space users
    bl version                       # show version
    bl wiki SUBCOMMAND ...ARGS       # manage wikis


### Examples

view global or command specific help:

    bl help
    bl help list
    bl help search
    bl help add

list overdue issues

    bl list --overdue

add an issue

    bl add "Update OpenSSL immediately" --priorityId 2 --assigneeId 11111 --dueDate 2014-04-07

add multi issues on list.txt

    cat list.txt | xargs -I {} bl add {}

update unassigned issues

    bl list --unassigned | awk '{print $2}' | xargs bl update --assigneeId 12345


## Backlog API

http://developer.nulab-inc.com/docs/backlog

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sakihet/bl.

## License

[MIT](http://opensource.org/licenses/MIT).
