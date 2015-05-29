# EuCookieLawMiddleware

**On June 2, 2015 the cookie law starts to be enforced, see http://www.cookielaw.org/the-cookie-law/**

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/eu_cookie_law_middleware`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eu_cookie_law_middleware', github: 'net2b/eu_cookie_law_middleware'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eu_cookie_law_middleware

## Usage

### Rails

In your `config/application.rb`:

```ruby
config.middleware.use EuCookieLawMiddleware

# or by passing some options:

config.middleware.use EuCookieLawMiddleware, {
  template_path: "#{__dir__}/eu_cookie_law_template.erb", # customize the html/behavior
  reload_code: Rails.env.development?,                    # reload the template in development
}
```

### Rack

In your `config.ru`:

```ruby
use EuCookieLawMiddleware

# or by passing some options:

use EuCookieLawMiddleware, {
  template_path: "#{__dir__}/eu_cookie_law_template.erb", # customize the html/behavior
  reload_code: Rails.env.development?,                    # reload the template in development
}
```

### Using a custom template

The ERB template is evaluated in the context of the middleware instance, which makes available the JavaScript code needed to mark the message as read with the `js_cookie_code` method.

```erb
<div
  style="
    position: fixed;
    display: block;
    bottom: 0;
    left: 0;
    right: 0;
    background-color: black;
    color: white;
    font-size: 0.8em;
    z-index: 100000;
    padding: 0.3em 1em;
    text-align: center;
  "
>
  <a
    href="#dismiss-cookie-alert"
    title="click to dismiss"
    onclick='
      <%= js_cookie_code %>
      this.parentNode.parentNode.removeChild(this.parentNode);
    '
    style="color:inherit; text-decoration: none;"
  >
    WE USE COOKIES TO IMPROVE OUR SITE.
    BY CONTINUING TO BROWSE OUR SITE YOU ACCEPT
  </a>

  <a href="/privacy" style="color:inherit; text-decoration: underline;">OUR COOKIE POLICY</a>
</div>
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/net2b/eu_cookie_law_middleware/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
