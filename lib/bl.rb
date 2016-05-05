require 'date'
require 'pp'
require 'backlog_kit'
require 'thor'
require 'bl/version'
require 'bl/config'
require 'bl/requestable'
require 'bl/category'
require 'bl/cli'

Bl::CLI.start(ARGV)
