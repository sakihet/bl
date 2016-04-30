# bl

bl is a command line tool for [Backlog](http://www.backlog.jp/).

## Installation

    gem install bl

## Configuration

bl uses `~/.bl.yml` for configuration.

    bl init
    $EDITOR ~/.bl.yml

## Usage

    bl activities      # list activities
    bl add SUBJECT     # add an issue
    bl categories      # list issue categories
    bl close KEY       # close an issue
    bl config          # show config
    bl count           # count issues
    bl help [COMMAND]  # Describe available commands or one specific command
    bl init            # initialize a default config file
    bl list            # list issues
    bl priorities      # list priorities
    bl projects        # list projects
    bl resolutions     # list resolutions
    bl search          # search issues
    bl show KEY        # show an issue's details
    bl statuses        # list statuses
    bl types           # list issue types
    bl users           # list space users
    bl version         # show version

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec bl` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sakihet/bl.

## License

[MIT](http://opensource.org/licenses/MIT).
