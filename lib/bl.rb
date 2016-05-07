require 'date'
require 'pp'
require 'backlog_kit'
require 'thor'
require 'bl/version'
require 'bl/config'
require 'bl/requestable'
require 'bl/type'
require 'bl/category'
require 'bl/milestone'
require 'bl/wiki'
require 'bl/cli'

Bl::CLI.start(ARGV)
