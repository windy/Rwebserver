require 'webrick'
require 'webrick/httpservlet/filehandler'
module WEBrick
  module HTTPServlet
    class FileHandler
      def nondisclosure_name?(name)
        @options[:NondisclosureName].each{|pattern|
          if File.fnmatch(pattern, name)
            return true
          end
        }
        return false
      end
    end
  end
end