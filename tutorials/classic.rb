require 'eyes_selenium'
require_relative '../resources/test_properties'

#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
#Applitools::EyesLogger.log_handler = Logger.new(STDOUT)

describe 'Search Tests' do

  before(:all) do
    @runner = Applitools::ClassicRunner.new
    @eyes = Applitools::Selenium::Eyes.new(runner: @runner)
    @eyes.batch = Applitools::BatchInfo.new("Demo Batch - Classic - Ruby")
    
    conf = Applitools::Selenium::Configuration.new.tap do |config|
      config.server_url = "https://eyesapi.applitools.com"
      config.api_key = API_KEY
      config.app_name = 'Demo App - Classic - Selenium for Ruby'
      config.test_name = 'Smoke Test - Classic - Selenium for Ruby'
      config.viewport_size = Applitools::RectangleSize.new(800, 600)
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
    
    # You can get a results object from eyes.close containing your test results. You can assert these values.
    results = @eyes.close
  end

  after(:all) do
    @driver.quit
    
    #  If the test was aborted before eyes.close / eyes.close_async was called, ends the test as aborted.
    @eyes.abort_if_not_closed
    
    # You can also get and print all test results here as well as assert them.
    puts @runner.get_all_test_results
  end
end