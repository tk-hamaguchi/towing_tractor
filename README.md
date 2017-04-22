TowingTractor
========

Docker controller plugin for Rails



Usage
--------

TBD

Installation
--------

Add this line to your application's Gemfile:

```ruby
gem 'towing_tractor'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install towing_tractor
```

Then mount your application with config/routes.rb

```ruby
Rails.application.routes.draw do
  mount TowingTractor::Engine, at: 'towing_tractor'
end
```


Contributing
--------

TBD

License
---------

MIT
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
