source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'
# Use mysql as the database for Active Record
group :development, :test do
  #Uses sqlite engine 
  gem 'sqlite3'
  gem 'faker'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  #modifies color reporting for tests
  gem 'minitest-reporters'
  #Shows backtrace on page hashes
  gem 'mini_backtrace'
  #Speeds up testing by keeping a live environment running for tests
  gem 'guard-minitest'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
# Allows working with csv files
gem 'csv-mapper'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'bcrypt'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
#Adds to_fraction function for ruby float datatypes
gem 'fraction'
#Adds uploading capabilities to application
gem 'carrierwave'
#Used to manage upload file modifications
gem 'mini_magick'
#Used to transfer uploads to filestore
gem 'fog'
#Used to ingterface with Amazon Cloud services 
gem 'aws-sdk'

#Overrides regular turbolinks for jquery scripts
gem 'jquery-turbolinks'

#Paginates records from db into pages
gem 'will_paginate'

gem 'geocoder'

gem 'amazon-ecs'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :production do
    gem 'pg'
    gem 'rails_12factor'
end