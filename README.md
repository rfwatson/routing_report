# routing_report

Identify cruft in a Rails app.

Detects:

* routes with no matching controller actions
* controller actions with no matching routes

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'routing_report'
```

And then execute:

    $ bundle

## Usage

`bundle exec rake routing_report:run`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rfwatson/routing_report.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

