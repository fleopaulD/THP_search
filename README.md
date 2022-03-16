# A simple Search Engine for "The Hacking Project" platform
>Allows you to easily find a course from the French programming school [The Hacking Project](https://www.thehackingproject.org/). Enter one or more keywords in the dedicated web extension and you have the resources!
#### Video Demo: [TODO]()

**Table of content**

- [A simple Search Engine for "The Hacking Project" platform](#a-simple-search-engine-for-the-hacking-project-platform)
      - [Video Demo: TODO](#video-demo-todo)
  - [Presentation](#presentation)
  - [Web extension](#web-extension)
    - [What it does](#what-it-does)
    - [How it does](#how-it-does)
    - [Install](#install)
  - [Backend](#backend)
    - [1. Database](#1-database)
    - [2. Scraper](#2-scraper)
    - [3. Db](#3-db)
    - [4. Search Engine](#4-search-engine)
    - [5. Search Controller](#5-search-controller)
    - [6. Others](#6-others)
      - [check_updates()](#check_updates)
  - [Install](#install-1)
    - [Requirements:](#requirements)
    - [Scraping tools](#scraping-tools)
    - [Procedure](#procedure)
    - [Environment variables](#environment-variables)
  - [More info](#more-info)
    - [About this project](#about-this-project)
    - [About scraping](#about-scraping)
    - [What I learned](#what-i-learned)

## Presentation

This search engine is based on a Ruby on Rails application for the backend, and on a webextension for the frontend.
Basically, the webextension sends a POST request to the Ruby on Rails application hosted on a Heoku server, then it returns a JSON file containing the search results.

## Web extension

The extension is in a separate repo which you can find here: [github.com/fleopaulD/THP_search_webextension](https://github.com/fleopaulD/THP_search_webextension)  

![web extension](readme_parts/webextension_details.png)

### What it does

This Firefox extension allows you to search for THP courses based on one or more keywords. Each click on a link opens a new tab with the appropriate article.

You may not have access to all the pages proposed. Moreover, only "Fullstack courses" are managed for the moment.

### How it does

When you click on the extension icon, a popup opens with a search field. An event listener is added to the search field and the submit button.
As soon as there is a validation, a POST request goes to the public API THP_search via an async function and fetch(). As soon as the response is received, the JSON file is parsed, then is inserted into the popup in the form of `<li>` tags.

### Install

This extension was designed on Firefox and it's not packaged yet.

To install it temporarily in Firefox :
- Open the page [about:debugging](about:debugging)
- Click on "This Firefox"
- Click on "Load Temporary Add-on..."
- Select the `manifest.json` file
- Application is activated

## Backend

Based on [Ruby on Rails](https://rubyonrails.org) version 7, this application has 5 main modules:

### 1. Database

This PostgreSQL database has 5 tables:
- `pages`: has basic informations on each article (title, url, signature)
- `words`: stores each word founded in pages. Each word is uniq
- join_tables:
  - `titles`: Represents each `word` found in a `title` belonging to each `page`
  - `subheadings`: Represents each `word` found in a `subheading` belonging to each `page`
  - `contents`: Represents each `word` found in a `content` belonging to each `page`. In this table we also have a counter that allows us to know how often a word appears, in order to highlight the most relevant articles during the search.

![DB Structure](/readme_parts/db_struct.jpg)

### 2. Scraper

Based on Selenium and geckodriver, this class contains all the methods to
- log in to "The Hacking Project" platform
- retrieve all available course urls for the registered account
- retrieve course content separated into "title", "subheadings" and "contents"

The content is returned in a hash with the keys :
- `[:title]`: is the title of the course. Most important words.
- `[:url]`: is the url of the course
- `[:signature]`: is the full page MD5 digest. By comparison, this will allow us to easily know if changes have been made to the article.
- `[:subheadings]`: is an array of all subheadings, i.e. words slightly less relevant than those in the title
- `[:contents]`: is an array of all other strings.

### 3. Db

This class automates the entire scraping and database process.  
`save_all_articles` method:
- start the scraper
- log into THP plateform
- Retrieves the content of each url in hash form as seen above
  - new `page` is created with its own values
  - each string is cleaned with a `cleanup_string(string)` method, this remove:
    - non alpha characters
    - all accents
    - words of less than 2 characters
    - non relevant words (`STOPWORDS` list contains 639 french words like "elsewhere", "enough", "today" or "relatively" for exemple)
  - the words are then created if they do not yet exist, then introduced into the appropriates join tables.

### 4. Search Engine

1. This method prepares a variable `results = []`, in which it will store the results found in the order of relevance.
2. User request is cleaned up with the method `cleanup_string` seen above
3. It retrieves each word entered in the user query, and check if there is an occurrence in the titles. If so, the `pages` concerned are placed in `results`
4. Same for subheadings.
5. Same for contents, except that `pages` will be added in descending order of occurrences.
6. `results` is returned.

### 5. Search Controller

It redirects a post request on `/search` to the `search_engine` class, transforms the collected data into JSON then returns it to the client.
A valid token is required to authenticate the request

### 6. Others

#### check_updates()

Is the function that checks that the local database is well synchronized with the online content.

1. Connects to the THP platform.
2. Retrieves all course urls available online.
3. Checks against the local database if a course has been added or removed.
4. Checks if the content of a page has been modified, thanks to the MD5 digest.
5. Returns a completed hash `{new_pages: [], removed_pages: [], modified_pages: []}`

## Install

### Requirements: 

| App         | version    |
|-------------|------------|
| Ruby        | 3.0.0      |
| Rails       | 7.0.2      |
| Firefox     | up-to-date |
| geckodriver | last       |

### Scraping tools

A procedure has been made to install everything necessary for scraping locally and on heroku [here](/doc/Installation_selenium.md)

### Procedure 

1. Clone repo
2. `bundle install`
3. `rails db:create`
4. `rails db:migrate`
5. `rails server`

### Environment variables

Locally, the `dotenv-rails` gem allows you to load the .env file into the environment. In Heroku they will have to be entered manually like `heroku config:set THP_SIGNIN_URL=your_value`

Required:

| ENV['variable']     | value      |
|---------------------|------------|
| THP_SIGNIN_URL      | your_value |
| THP_ALL_COURSES_URL | your_value |
| THP_USER_EMAIL      | your_value |
| THP_USER_PASSWORD   | your_value |
| API_USER_TOKEN      | your_value |

## More info

### About this project

This idea for this project was born when I was doing my first training in computer programming, at The Hacking Project. I especially thank them for making me discover this world of programming, web applications and algorithmic logic, in a spirit of sharing, hardship and mutual aid!
The propensity that we have to want to optimize our life, as soon as we begin to understand the tools, is incredible!  

### About scraping

Scraping is rather frowned upon and is not tolerated everywhere, some companies may resort to IP or account bans in the event of abuse of these methods.
For the purpose of transparency and respect, I have notified The Hacking Project of this project, and although the data cannot be used as it is in the database, it will be destroyed as soon as cs50 certification is obtained.  
In general and to be within your rights, consult the `/robots.txt` file of the website to get an idea of what you have the right to do, or not. [More info here](https://www.robotstxt.org/robotstxt.html)

### What I learned

I started training in computer programming to understand what was happening physically between my keyboard and my screen. Thanks to THP I learned the high level mechanics of this whole paradigm, and thanks to cs50 I was able to dig into what is happening at a lower level, thanks to C language.  

I learned a lot, and what I learned is that the more you learn, the more there is to learn, for my greatest pleasure!

With love, fleopaulD