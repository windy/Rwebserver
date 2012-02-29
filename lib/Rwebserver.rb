if $0 == __FILE__
  $LOAD_PATH.unshift File.dirname(__FILE__)
end
require "Rwebserver/version"
require 'webrick'
require 'logger'

module Rwebserver
  def self.start(port=8888,logger = Logger.new(STDOUT))
    current_dir = Dir.pwd
    server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => current_dir
    logger.info("start serve for dir: #{current_dir}")
    trap 'INT' do
      logger.info("stop serve")
      server.shutdown
    end
    server.start
  end
end

if $0 == __FILE__
  Rwebserver.start
end
