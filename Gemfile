source 'https://rubygems.org'

# ------------------------------------------------------------------------------
# ZIGVU BEGIN: Original gems from rails new

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# EVAN: not needed since we use node.js with lower memory footprint - so don't uncomment
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'spring'
end

# ZIGVU END: Original gems from rails new
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ZIGVU BEGIN: Additional gems

# scaffold and view helpers
# NOT USING: gem 'bootstrap-glyphicons' # although using foundation, use icons from bootstrap
gem 'foundation-rails' # CSS library
gem 'foundation-icons-sass-rails' # icons from foundation
# NOT USING: gem 'foundation_rails_helper' # formatting for alerts etc.
gem 'gretel' # for breadrums
# NOT USING: gem 'fancybox2-rails', '~> 0.2.8' # pop-up image in fancy box
gem 'simple_form' # simple form with foundations configuration
gem 'draper', '~> 1.3' # decorator

# authentication and roles
gem 'devise' # for authentication
gem 'simple_token_authentication' # for API authentication using devise
gem 'authority' # for authorization
# NOT USING: gem 'rolify' # for role management

# analytics
gem 'd3-rails' # main JS charting library
gem 'crossfilter-rails' # JS data filter library

# misc.
gem 'high_voltage', '~> 2.4.0' # serve static pages for test
gem 'quiet_assets', group: :development # quits the asset prints in console
# NOT USING: gem 'parallel' # multi-threading

# delayed_job
# NOT USING: gem 'delayed_job_active_record' # background jobs
# NOT USING: gem 'delayed_job_web' # view background job status
# NOT USING: gem 'daemons' # dependency for delayed job

# memcached
gem 'dalli' # gem for memcached
# NOT USING: Now part of rails: gem 'cache_digests'    # to expire view partials
gem 'kgio', '~> 2.10.0' # makes dalli 20-30% faster as per dalli github page
gem 'connection_pool' # enable dalli to share pooled connections

# document store
gem 'mongoid', '~> 5.0.0' # driver for mongo

# serving
gem 'puma'

# kheer specific - not in cellroti
gem 'bunny' # for rabbitmq
gem 'wicked' # campaign
gem 'her' # Use Cellroti API as model objects

# javascript libraries
gem 'underscore-rails' # JS helper library
gem 'jquery-ui-rails', '~> 5.0.2' # JS UI assets
gem 'jquery-turbolinks' # have turbolinks play nice with JS

# ZIGVU END: Additional gems
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ZIGVU BEGIN: Internal engines

gem 'messaging', path: 'engines/messaging'
gem 'admin', path: 'engines/admin'
gem 'video', path: 'engines/video'

# ZIGVU END: Internal engines
# ------------------------------------------------------------------------------
