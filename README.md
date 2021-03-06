### Opinion

This project rocks and uses MIT-LICENSE.

#### Usage

This gem is used to obtain opinions of users of a rails application.

##### Configure User object

Opinions can be obtained be users authenticated using devise, but other solutions can also be used.

To configure the main user object for opinion, add 'act_as_voter' in it's class. In the following example we use a devise generated object for voting.

```ruby
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_voter
end
```

##### Configuring Opinion

To use opinion in your rails application you need to follow these steps:

Add bootstrap and other assets to application.

```js
//= require opinion/polls
//= require bootstrap-sprockets
```

Add bootstrap css files to your application.css.scss like the bootstrap-sass gem guides you to.

```css
@import "bootstrap-sprockets";
@import "bootstrap";
```

 * Add initializer

    ```ruby
    Rails.application.config.to_prepare do
      # If you want to change the layout that Opinion uses, uncomment and customize the next line:
      # Opinion::ApplicationController.layout 'application'
    end

    # Adds Opinion functionality to application controller, can be disabled using helpers_to_application configuration option. 
    Opinion.configure
    ```

##### Option helpers\_to\_application.

To be able to use opinion in controllers in the rails application, you can

 * Add functionality to complete application.

    ```ruby
    # Adds Opinion functionality to application controller, can be disabled using helpers_to_application configuration option. 
    Opinion.configure
    ```

 * Add functionality to required controllers.

    ```ruby
    # Adds Opinion functionality to application controller, can be disabled using helpers_to_application configuration option. 
    Opinion.configure.do |config|
      config.helpers_to_application = false
    end

    # Adds Opinion functionality to WelcomeController and SignOutController.
    Opinion.opinion_for :welcome, :sign_out
    ```

##### Option user\_getter.

This option is used to specify which object is used to get the user object in the application, most likely and default it is \:current\_user. 

 * Set the method current\_client to be used to retrieve the signed-in user \(client\) object.

    ```ruby
    Opinion.configure.do |config|
      # Set method to retrieve client who is signed in.
      config.user_getter = :current_client
    end
    ```

##### Option end\_poll\_on\_activate.

This option is used to enable/disable ending activated polls when a pending poll is being activated. Which means that a pending poll can only
be activated when no active polls exists when the option is disabled. By default the option is disabled.

 * Enable ending activated polls when a pending poll is activated.

    ```ruby
    Opinion.configure.do |config|
      # Enable ending activated polls when a pending poll is activated.
      config.end_poll_on_activate = true
    end
    ```

Opinion can be used with- or without bootstrap.

#### Showing votes

By default a pie chart using the google-api is used to show votes. This can be overridden using the options:

 * charts_engine
 * charts_engine_location

The option charts\_engine is used to specify the engine to use, :google_charts and :highcharts are supported. 
The Google-charts API and Highcharts cannot be used mixed together.

##### Google-charts API

 * To use the google-charts API in a different layout as the default layout, include the following code in the layout file, by using

    ```ruby
    <%= javascript_include_tag '//www.google.com/jsapi', 'chartkick' %>
    ```

##### Highcharts

 * To use [highcharts](www.highcharts.com) which is not included in this gem, download the js and add it in the applications directory of your rails app. Than make sure the configuration is set correctly. By using

    ```ruby
    Opinion.configure do |config|
      config.charts_engine = :highcharts
      # This will find highcharts-all.js in app/assets/javascripts/
      config.charts_engine_location = 'highcharts-all.js'
    end
    ```

### Showing opinion-panel

The opinion-panel, used to vote, can be shown every once in a while, which can be more convenient for the user. 

To do this use the following config:
 
```ruby
Opinion.configure do |config|
  # Default = :enable
  config.vote_later_type = :on_close
  config.vote_later_wait = 300 # 300 seconds = 5 minutes
end
```

Another option to show the opinion-panel not instantly for example can be achieved by overriding the method opinion_show_poll?.

The method opinion_show_poll? is used to check whether to show the opinion-panel.

For example: Add the following to the opinion initializer. 

```ruby
Opinion::ControllerHelper.class_eval do
	# Whether the poll should be displayed.
	#
	# @return [Boolean] Whether the poll should be displayed.
	def opinion_show_poll?
		begin
			unless opinion_user.nil?
				# devise user needs to be trackable
				return opinion_user.sign_in_count > 1 || opinion_user.last_sign_in_at + 300.seconds < Time.zone.now
			end
		rescue NoMethodError
			false
		end
	end
end
```

#### Vote later types

The following vote later types exists:

 * enable
 
 Enables 'Vote Later' button, which is only used to set waiting time (vote_later_wait), the other close options are not setting the wait.
 
 * on_close
 
 Enables waiting time for every available close option. No 'Vote Later' button will be added.
 
 * never
 
 Never use waiting time.

### Production mode

To use opinion in production-mode, set serving static to true by

```ruby
config.serve_static_assets = true
```

#### Without bootstrap

##### Using different layout.

 * Add jquery\_nested\_form to javascript assets.

##### Generate views

To generate views which can be edited use the following generator:

```shell
rails generate opinion:views
```

##### ThumbsUp tests (See thumbs\_up gem)

Testing is a bit more than trivial now as our #tally and #plusminus\_tally queries don't function properly under SQLite. To set up for testing:

* mysql (not tested)

    ```shell
      mysql -uroot # You may have set a password locally. Change as needed.
        CREATE USER 'opinion_root'@'localhost' IDENTIFIED BY 'opinion_root';
        CREATE DATABASE opinion_test;
        USE opinion_test;
        GRANT ALL PRIVILEGES ON opinion_test TO 'opinion_root'@'localhost' IDENTIFIED BY 'opinion_root';
        exit;
    ```
* Postgres

    ```shell
      psql -c 'CREATE ROLE opinion_root;'
      psql -c 'ALTER ROLE opinion_root WITH SUPERUSER;'
      psql -c 'ALTER ROLE opinion_root WITH LOGIN;'
      psql -c 'CREATE DATABASE opinion_test;'
      psql -c 'GRANT ALL PRIVILEGES ON DATABASE opinion_test to opinion_root;'
    ```
* Run tests

    
    ```shell
      export DB=postgres # or mysql to use the mysql database.
      bundle exec rake # Runs the test suite against all adapters.
    ```
