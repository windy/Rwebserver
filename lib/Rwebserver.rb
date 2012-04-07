if $0 == __FILE__
  $LOAD_PATH.unshift File.dirname(__FILE__)
end
require "Rwebserver/version"
require 'webrick'
if RUBY_VERSION =~ /1.9/
  require "Rwebserver/filehandler_ext"
  require "Rwebserver/httputils_ext"
end
require 'logger'
BasicSocket.do_not_reverse_lookup=true
module Rwebserver
  def self.start(port=8000,logger = Logger.new(STDOUT))
    current_dir = Dir.pwd
    server = WEBrick::HTTPServer.new :Port => port, :DocumentRoot => current_dir
    logger.info("start serve for dir: #{current_dir}")
    logger.info("url: http://127.0.0.1:#{port}")
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
