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

    bl activities      # list activities
    bl add *SUBJECTS   # add issues
    bl browse KEY      # browse an issue
    bl categories      # list issue categories
    bl close *KEYS     # close issues
    bl config          # show config
    bl count           # count issues
    bl help [COMMAND]  # Describe available commands or one specific command
    bl init            # initialize a default config file
    bl list            # list issues
    bl milestones      # list milestones
    bl priorities      # list priorities
    bl projects        # list projects
    bl resolutions     # list resolutions
    bl search          # search issues
    bl show KEY        # show an issue's details
    bl statuses        # list statuses
    bl types           # list issue types
    bl update KEY      # update an issue
    bl users           # list space users
    bl version         # show version

### Example

update unassigned issues

    bl list --unassigned | awk '{print $2}' | xargs -L 1 bl update --assigneeId 12345

add multi issues on list.txt

    cat list.txt | xargs -I {} bl add {}


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sakihet/bl.

## License

[MIT](http://opensource.org/licenses/MIT).
