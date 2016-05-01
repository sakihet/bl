require 'thor'
require 'backlog_kit'
require 'bl/version'
require 'yaml'
require 'pp'
require 'bl/cli'

Bl::CLI.start(ARGV)
