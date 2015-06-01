# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eu_cookie_law_middleware/version'

Gem::Specification.new do |spec|
  spec.name          = "eu_cookie_law_middleware"
  spec.version       = EuCookieLawMiddleware::VERSION
  spec.authors       = ["Elia Schito"]
  spec.email         = ["elia@schito.me"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{On June 2, 2015 the cookie law starts to be enforced}
  spec.description   = %q{On June 2, 2015 the cookie law starts to be enforced, see http://www.cookielaw.org/the-cookie-law/.}
  spec.homepage      = 'https://github.com/Net2b/eu_cookie_law_middleware#readme'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rack', '~> 1.5'

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
