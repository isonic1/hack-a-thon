require 'eyes_selenium'
require_relative './resources/test_properties'
require_relative './resources/page_objects'
require 'pry'

describe 'Search Tests' do

  before(:all) do
    # If your chromedriver is not global. Specify your chromedriver path on next line. 
    # Selenium::WebDriver::Chrome.driver_path = "./chromedriver/chromedriver"
    @driver = Selenium::WebDriver.for :chrome
    @page = SearchPage.new(@driver)
    @driver.get APP_URL
  end

  it 'Search By Full Title' do
    title = "Agile Testing"
    @page.search title
    expect(@page.is_book_visible?(title)).to eq true
    expect(@page.get_number_of_visible_books).to eq 1
  end

  it 'Validate Example.com' do |e|
    @page.search("Test");

    expected_books = [
      "Test Automation in the Real World",
      "Experiences of Test Automation",
      "Agile Testing",
      "How Google Tests Software",
      "Java For Testers"
    ]
    
    expected_books.each do |book_title|
      expect(@page.is_book_visible?(book_title)).to eq true
    end
    
    expect(@page.get_number_of_visible_books).to eq expected_books.size
  end

  after(:all) do
    @driver.quit
  end
end