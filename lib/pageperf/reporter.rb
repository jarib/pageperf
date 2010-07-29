require "restclient"
require "uri"

RestClient.log = "/tmp/restclient-pageperf.log"

module PagePerf
  class Reporter
    
    def initialize(test_id, server_url, directory)
      @test_id    = test_id
      @server_url = server_url
      @session_id = -1
      @files      = Dir[File.join(directory, "*.har")].sort_by { |f| File.mtime(f) }
    end
    
    def process
      @files.each { |file| submit_file file }
    end
    
    private
    
    def submit_file(file)
      resp = RestClient.post uri.to_s, File.open(file, "r"), :content_type => "text/json"
      @session_id = Integer(resp)
    rescue RestClient::RequestFailed => ex
      $stderr.puts "Could not submit #{file.inspect} (code #{ex.http_code})\n#{ex.http_body}"
    end
    
    def uri
      URI.join(@server_url, "har", "?testId=#{URI.escape @test_id.to_s}&sessionId=#{URI.escape @session_id.to_s}")
    end
    
  end # Reporter
end # PagePerf
