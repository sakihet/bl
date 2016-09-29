require 'date'
require 'pp'
require 'backlog_kit'
require 'paint'
require 'thor'
require 'bl/version'
require 'bl/config'
require 'bl/requestable'
require 'bl/formatting'
require 'bl/space'
require 'bl/type'
require 'bl/category'
require 'bl/milestone'
require 'bl/wiki'
require 'bl/project'
require 'bl/recent'
require 'bl/file'
require 'bl/gitrepo'
require 'bl/cli'

Bl::CLI.start(ARGV)
