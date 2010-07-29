require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "PagePerf::Driver" do
  before { @driver = PagePerf::Driver.new("spec", "http://localhost:8080") }
  
  it "reports some files" do
    @driver.get "http://google.com"
    files = @driver.quit
    files.should_not == []
  end
end
