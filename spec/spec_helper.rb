$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'pageperf'
require 'spec'
require 'spec/autorun'


# Selenium::WebDriver::FileReaper.reap = false

Spec::Runner.configure do |config|
end

