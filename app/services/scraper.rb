class Scraper
  attr_accessor :driver

  def initialize
    options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
    @driver = Selenium::WebDriver.for(:firefox, options: options)
  end

  def login
    begin
      self.driver.get "https://www.thehackingproject.org/users/sign_in"
      self.driver.find_element(id: "user_email").send_keys ENV["THP_USER_EMAIL"]
      self.driver.find_element(id: "user_password").send_keys ENV["THP_USER_PASSWORD"], :return
    rescue => exception
      puts "Error during login to THP website (#{exception})"
      kill()      
    end
  end
  
  def kill
    self.driver.quit()
  end

end