class Scraper
  attr_accessor :driver, :all_articles_urls

  def initialize
    options = Selenium::WebDriver::Firefox::Options.new # (args: ['-headless'])
    @driver = Selenium::WebDriver.for(:firefox, options: options)
    @all_articles_urls = []
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
  
  def get_articles_urls
    begin
      self.driver.get ENV["THP_ALL_COURSES_URL"]
      href_elements = self.driver.find_elements(:tag_name, 'a')
      href_elements.each do |a|
        href = a.dom_attribute("href")
        @all_articles_urls << href.prepend("https://www.thehackingproject.org") if href =~ /fr\/dashboard\/courses\/\d{1,2}\/(lessons|projects)\/\d{1,4}/
      end
    rescue => exception
      puts "Error in get_articles_url() -> #{exception}"
      kill()
      return false
    end
    @all_articles_urls.count > 0 ? true : false
  end

  def get_content(url)
    article = {}
    begin
      self.driver.get url
      raw_page = self.driver.find_element(:class_name, "card")
      article[:title] = raw_page.find_element(:class_name, "card-title").text
      article[:url] = url
      article[:hash] = raw_page.text.hash.to_s
      article[:subtitles] = raw_page.find_elements(css: ".card-body h2, .card-body h3, .card-body h4, .card-body h5").map { |a| a.text }
      article[:contents] = raw_page.find_elements(css: ".card-body p, .card-body li").map { |a| a.text }
    rescue => exception
      puts "Error in Scraper.get_content(...) -> #{exception}"
      kill()
    end
    article
  end
  
  def kill
    self.driver.quit()
  end

  def perform
    self.login()
    self.get_articles_urls()
  end
end