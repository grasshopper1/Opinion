### Opinion

This project rocks and uses MIT-LICENSE.

#### Usage

##### Configuring Opinion

To use opinion in your rails application you need to follow these steps:

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

This option is used to specify which object is used to get the user object in the application, most likely and default it is :current\_user.

In this example the method current\_client will be used to retrieve the user (client) object.

    ```ruby
    Opinion.configure.do |config|
      # Set method to retrieve client who is signed in.
      config.user_getter = :current_client
    end
    ```

##### Option end\_poll\_on\_activate.

This option is used to enable/disable ending activated polls when a pending poll is being activated. Which means that a pending poll can only
be activated when no active polls exists when the option is disabled. By default the option is disabled.

    ```ruby
    Opinion.configure.do |config|
      # Enable ending activated polls when a pending poll is activated.
      config.end_poll_on_activate = true
    end
    ```

Opinion can be used with- or without bootstrap.

#### Without bootstrap

##### Using different layout.

 * Add jquery\_nested\_form to javascript assets.

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