module PagePerf
  
  class Driver < Selenium::WebDriver::Driver
    attr_reader :profile_dir
    
    def initialize(test_id, server_url)
      @test_id    = test_id
      @server_url = server_url
      
      bridge = Selenium::WebDriver::Firefox::Bridge.new(:profile => create_profile)
      super(bridge)
    end
    
    def quit
      get "http://example.com" # unload
      sleep 1
      
      super
      
      Reporter.new(@test_id, @server_url, log_dir).process
    end
    
    def log_dir
      Dir[File.join(@profile_dir, "firebug/netexport/logs")]
    end
    
    private
    
    def create_profile
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile.add_extension File.join(xpi_dir, "firebug-1.6X.0a7.xpi")
      profile.add_extension File.join(xpi_dir, "fireStarter-0.1.a5.xpi")
      profile.add_extension File.join(xpi_dir, "netExport-0.7b13-mob.xpi")

      profile["extensions.firebug.netexport.autoExportActive"] = true
      profile["extensions.firebug.DBG_NETEXPORT"]              = true
      profile["extensions.firebug.onByDefault"]                = true
      profile["extensions.firebug.defaultPanelName"]           = "net"
      profile["extensions.firebug.net.enableSites"]            = true
      profile["extensions.firebug.previousPlacement"]          = 1
      
      @profile_dir = profile.directory
      
      profile
    end
    
    def xpi_dir
      @xpi_dir ||= File.join(File.dirname(__FILE__), "extensions")
    end
    
  end # Driver
end # PagePerf