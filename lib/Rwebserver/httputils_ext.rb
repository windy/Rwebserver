require 'webrick'
require 'webrick/httputils'

module WEBrick
  module HTTPUtils
    module_function
    def _escape(str, regex) 
      str.force_encoding('ASCII-8BIT').gsub(regex){ "%%%02X" % $1.ord }
    end
  end
end