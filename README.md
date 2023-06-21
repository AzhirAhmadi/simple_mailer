# SIMPLE MAILER

* Description
    - This is a simple mailer application that allows users:
        - To send emails to other users.(in development)
        - To read from their mailbox.
    

* Ruby version
    3.1.3

* System dependencies
    - Ruby
    - Rails
    - Postgresql

* Configuration
    - `bundle install`

* Database initialization
    - copy .evn.sample to .env
    - set database credentials in .env
    - `rails db:create`
    - `rails db:migrate`

* How to run the test suite
    - `rails rspec spec`

* Deployment instructions
    - `rails s`

* Api documentation
    - `rails rswag` or `rails rswag:specs:swaggerize`
    - `rails s`
    - `http://localhost:3000/api-docs/index.html`
