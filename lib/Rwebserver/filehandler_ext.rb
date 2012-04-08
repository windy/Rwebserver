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

      def set_dir_list(req, res)
        redirect_to_directory_uri(req, res)
        unless @options[:FancyIndexing]
          raise HTTPStatus::Forbidden, "no access permission to `#{req.path}'"
        end
        local_path = res.filename
        list = Dir::entries(local_path).collect{|name|
          next if name == "." || name == ".."
          next if nondisclosure_name?(name)
          next if windows_ambiguous_name?(name)
          st = (File::stat(File.join(local_path, name)) rescue nil)
          if st.nil?
            [ name, nil, -1 ]
          elsif st.directory?
            [ name + "/", st.mtime, -1 ]
          else
            [ name, st.mtime, st.size ]
          end
        }
        list.compact!

        if    d0 = req.query["N"]; idx = 0
        elsif d0 = req.query["M"]; idx = 1
        elsif d0 = req.query["S"]; idx = 2
        else  d0 = "A"           ; idx = 0
        end
        d1 = (d0 == "A") ? "D" : "A"

        if d0 == "A"
          list.sort!{|a,b| a[idx] <=> b[idx] }
        else
          list.sort!{|a,b| b[idx] <=> a[idx] }
        end

        res['content-type'] = "text/html"

        res.body = <<-_end_of_html_
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<HTML>
  <HEAD><TITLE>Index of #{HTMLUtils::escape(req.path)}</TITLE></HEAD>
  <BODY>
    <H1>Index of #{HTMLUtils::escape(req.path)}</H1>
        _end_of_html_

        res.body << "<PRE>\n"
        res.body << " <A HREF=\"?N=#{d1}\">Name</A>                          "
        res.body << "<A HREF=\"?M=#{d1}\">Last modified</A>         "
        res.body << "<A HREF=\"?S=#{d1}\">Size</A>\n"
        res.body << "<HR>\n"

        list.unshift [ "..", File::mtime(local_path+"/.."), -1 ]
        list.each{ |name, time, size|
          if name == ".."
            dname = "Parent Directory"
          elsif name.bytesize > 25
            dname = name.sub(/^(.{23})(?:.*)/, '\1..')
          else
            dname = name
          end
          s =  " <A HREF=\"#{HTTPUtils::escape(name)}\">#{HTMLUtils::escape(dname)}</A>"
          # fixbug: greater than 30 chars with cause negative argument Error
          size = dname.bytesize > 30 ? 30 : dname.bytesize
          s << " " * (30 - size)
          s << (time ? time.strftime("%Y/%m/%d %H:%M      ") : " " * 22)
          s << (size >= 0 ? size.to_s : "-") << "\n"
          res.body << s
        }
        res.body << "</PRE><HR>"

        res.body << <<-_end_of_html_
    <ADDRESS>
     #{HTMLUtils::escape(@config[:ServerSoftware])}<BR>
     at #{req.host}:#{req.port}
    </ADDRESS>
  </BODY>
</HTML>
        _end_of_html_
      end
    end
  end
end