# Procedure to install the necessary to the Scraper

## 1. Add to Gemfile

```
# Scrap the web
gem 'selenium-webdriver', '~> 4.0'`
gem 'webdrivers'
```

## 2. Installing Firefox

### 2.1 On the Computer

1. [Download geckodriver](https://github.com/mozilla/geckodriver/releases)
1. Put it in PATH

### 2.2 On Heroku

```
# Add buildpack to heroku app
heroku buildpacks:add https://github.com/pyronlaboratory/heroku-integrated-firefox-geckodriver

# Add necessary environment variables (in the .env and on heroku)
heroku config:set FIREFOX_BIN=/app/vendor/firefox/firefox
heroku config:set GECKODRIVER_PATH=/app/vendor/geckodriver/geckodriver
heroku config:set LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib:/app/vendor
heroku config:set PATH=/app/vendor:/app/bin:/app/vendor/bundle/bin:/app/vendor/bundle/ruby/3.0.0/bin:/usr/local/bin:/usr/bin:/bin:/app/vendor/firefox
```

## 3. Syntax example for starting an instance of the driver

```
# Driver settings
opts = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])

# Driver creation
driver = Selenium::WebDriver.for(:firefox, options: opts)
```

## 4. More infos

[Buildpack link](https://elements.heroku.com/buildpacks/pyronlaboratory/heroku-integrated-firefox-geckodriver)

[Selenium website](https://www.selenium.dev/documentation/)