#!/usr/bin/env ruby

root_path    = File.expand_path(File.join(File.dirname(__FILE__), '.'))
gremlin_path = File.join(root_path, 'lib')
$LOAD_PATH << gremlin_path unless $LOAD_PATH.include? gremlin_path

require 'dynflow'
require 'gremlin'
require 'tmpdir'

socket              = File.join('/tmp', 'dynflow_socket')
persistence_adapter = Dynflow::PersistenceAdapters::Sequel.new ARGV[0] || 'sqlite://db.sqlite'
world               = Dynflow::SimpleWorld.new persistence_adapter: persistence_adapter
listener            = Dynflow::Listeners::Socket.new world, socket
plugin_path         = File.join(File.dirname(__FILE__),"/","plugins")


lib_glob = File.join(File.join(plugin_path),'**', '*.rb')


library_files  = Dir.glob(lib_glob)

library_files.each {|file| p file ; require file}
Dynflow::Daemon.new(listener, world).run