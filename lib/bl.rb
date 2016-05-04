require 'thor'
require 'backlog_kit'
require 'bl/version'
require 'bl/category'
require 'yaml'
require 'pp'
require 'bl/cli'
require 'date'

Bl::CLI.start(ARGV)
