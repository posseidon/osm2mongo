require 'uri'
require 'net/http'
require 'progressbar'

# Responsible for Http actions.
# 
# Purpose:
# - Downloading partial files.
# - Write file content into given destination.
#
# Depends:
# - Progressbar: http://0xcc.net/ruby-progressbar/index.html.en 
#
# TODO: handle http errors
#
# Author::    Binh Nguyen (ntb@inf.elte.hu)
# License::   Distributes under the same terms as Ruby
#
# This module contains:
# - Downloader Class: file downloader
#
module Preprocessor
    
    UNITS = %W(B KiB MiB GiB TiB).freeze
    
    def Preprocessor.download(url, destination)
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host)
        size = http.request_head(url)['content-length'].to_f
        counter = 0
        file = open(destination.concat(uri.path.split("/").last), "wb")
        begin
            pbar = ProgressBar.new("Downloading: ", size)
            http.request_get(uri.path) do |response|
                response.read_body do |segment|
                    file.write(segment)
                    counter += segment.length 
                    pbar.set(counter)
                end
            end
        rescue
            return {'error' => "HTTP Error"}
        ensure
            file.close()
        end
        return {'path' => file.path}
    end
    
    def Preprocessor.extract(source)
        begin
            IO.popen("bunzip2 #{source}")
            return {'path' => source.gsub!(".bz2","")}
        rescue Exception => e
            return {'path' => e}
        end
    end


    def Preprocessor.as_size number
      if number.to_i < 1024
        exponent = 0

      else
        max_exp  = UNITS.size - 1

        exponent = ( Math.log( number ) / Math.log( 1024 ) ).to_i # convert to base
        exponent = max_exp if exponent > max_exp # we need this to avoid overflow for the highest unit

        number  /= 1024 ** exponent
      end

      "#{number} #{UNITS[ exponent ]}"
    end

end