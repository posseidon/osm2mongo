require 'uri'
require 'net/http'
require 'progressbar'
require 'nokogiri'
require 'observer'


# Responsible for Http actions.
# 
# Purpose:
#  Preprocessing OSM data format, begins with downloading it, to importing into MongoDB.
#
# Depends:
# - Nokogiri: XML Parser
# - Progressbar: http://0xcc.net/ruby-progressbar/index.html.en 
#
# This module contains:
# - Downloader method: file downloader
# - Decompressor method: unpack gzip2 osm file.
# - 
#
class Common
    include Observable
    
    UNITS = %W(B KiB MiB GiB TiB).freeze
    READ = "r"
    ENDL = "\n"
    INFO = Struct.new(:name)
    DONE = "done"
    
    
    #
    # Download file. On success returns absolute path of downloaded file.
    # ==== Attributes
    # * +url+ Url address of file.
    # * +destination+ Where to download it.
    # ==== Examples
    #     result = Common::download("http://someurl.com/somedata.txt","/tmp/")
    #
    def download(url, destination)
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
            pbar.finish
        ensure
            file.close()
        end
        return {'path' => file.path}
    end
    
    #
    # Decompress a GZIP2 file to its actual path.
    # ==== Attributes
    # * +source+ Absolute path of archive file.
    # ==== Examples
    #     result = Common::decompress("/tmp/hungary.osm.bz2")
    #
    def decompress(source)
        command = Thread.new do
          system("bunzip2 #{source}") # long-long programm
        end
        command.join
        return {'path' => source.gsub!(".bz2","")}
    end

    #
    #  Push OSM XML content into Database.
    # ==== Attributes
    # * +osm+ absolute path to osm file.
    # * +host+ MongoDB host
    # * +port+  MongoDB port number
    # * +db_name+ Name of database
    # * +collection_name+ Collection name
    # * +batch_limit+ Limit of Array for batch insert (carefull, it may vary on architecture).
    # ==== Examples
    #     result = Common::push2mongo("/tmp/map.osm", "osm",  collections, 1000)
    #
    def parse(osm_file)
        File.open(osm_file, READ) do |osm|
            reader = Nokogiri::XML::Reader(osm)
            reader.read()
            while reader.read()
                unless reader.value?
                    changed()
                    notify_observers(reader)
                end
            end
            changed()
            notify_observers(INFO.new(DONE))
        end
    end
    

    #
    # Print File size as readable.
    # ==== Attributes
    # * +size+ size in bytes
    # ==== Examples
    #     result = Common::as_size("53344233")
    #
    def as_size number
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