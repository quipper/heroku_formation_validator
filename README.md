# Heroku Formation Validator


## Installation

    $ gem install heroku_formation_validator

## Usage

### Create your formation.yml

```
auth:
  user: <heroku email address>
  token: <heroku token>

common:
  addons:
    - "newrelic:stark"
    - "redistogo:mini"
    - "scheduler:standard"
    - "sendgrid:bronze"
  variables:
    MONGO_DATABASE: "ABC"
  papertrail: true

groups:
  api:
    apps:
      - <your app name on heroku>
    variables:
    - YOUR_VARIABLE: "ABC"
```

### Run it (Usually, in CI)

```
$ heroku_formation_validator formation.yml
```

- When no errors, you will get nothing with exit code 0
- When errors, You will get errors with exit code 1

## Contributing

1. Fork it ( http://github.com/quipper/heroku_formation_validator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
