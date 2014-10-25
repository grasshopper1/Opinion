##### Opinion

This project rocks and uses MIT-LICENSE.

#### Usage

TODO

#### ThumbsUp tests (See thumbs\_up gem)

Testing is a bit more than trivial now as our #tally and #plusminus_tally queries don't function properly under SQLite. To set up for testing:

* mysql

    ```
    $ mysql -uroot # You may have set a password locally. Change as needed.
      > CREATE USER 'opinion_root'@'localhost' IDENTIFIED BY 'opinion_root';
      > CREATE DATABASE opinion_test;
      > USE opinion_test;
      > GRANT ALL PRIVILEGES ON opinion_test TO 'opinion_root'@'localhost' IDENTIFIED BY 'opinion_root';
      > exit;
    ```
* Postgres (

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
      rake # Runs the test suite against all adapters.
    ```