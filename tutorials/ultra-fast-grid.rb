require 'eyes_selenium'
require_relative '../resources/test_properties'

#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
#Applitools::EyesLogger.log_handler = Logger.new(STDOUT)

describe 'Search Tests' do

  before(:all) do
    @runner = Applitools::Selenium::VisualGridRunner.new(10)
    @eyes = Applitools::Selenium::Eyes.new(runner: @runner)
    @eyes.batch = Applitools::BatchInfo.new("Demo Batch - Ultrafast - Selenium for Ruby")
    
    conf = Applitools::Selenium::Configuration.new.tap do |config|
      config.server_url = "https://eyesapi.applitools.com"
      config.api_key = API_KEY
      config.app_name = 'Demo Batch - Ultrafast - Selenium for Ruby'
      config.test_name = 'Smoke Test - Ultrafast - Selenium for Ruby'
      config.viewport_size = Applitools::RectangleSize.new(800, 600)
      config.add_browser(800, 600, BrowserType::CHROME)
            .add_browser(700, 500, BrowserType::FIREFOX)
            .add_browser(800,600, BrowserType::SAFARI)
            .add_browser(1600,1200, BrowserType::IE_11)
            .add_browser(1024,768, BrowserType::EDGE_CHROMIUM)
      #  Add mobile emulation devices in Portrait mode
      config.add_device_emulation(Devices::IPhoneX, Orientation::PORTRAIT)
            .add_device_emulation(Devices::Pixel2, Orientation::PORTRAIT)
    end
    
    @eyes.set_configuration(conf)
    @driver = Selenium::WebDriver.for :chrome
  end

  it 'Search By Full Title' do |e|
    @eyes.open(driver: @driver)

    # Navigate to the url we want to test
    @driver.get('https://demo.applitools.com')

    # check the login page
    @eyes.check(name: 'Login window', target: Applitools::Selenium::Target.window.fully)

    # Click the 'Log In' button
    @driver.find_element(:id, 'log-in').click

    # Check the app page
    @eyes.check(name: 'App window', target: Applitools::Selenium::Target.window.fully)
    
    @eyes.close_async
  end

  after(:all) do
    @driver.quit
    
    #  If the test was aborted before eyes.close / eyes.close_async was called, ends the test as aborted.
    @eyes.abort_async
    
    # You can also get and print all test results here as well as assert them.
    puts @runner.get_all_test_results
  end
end