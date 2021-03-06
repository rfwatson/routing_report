# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'routing_report/version'

Gem::Specification.new do |spec|
  spec.name          = "routing_report"
  spec.version       = RoutingReport::VERSION
  spec.authors       = ["Rob Watson"]
  spec.email         = ["rob@mixlr.com"]

  spec.summary       = %q{Identify unused routes and controller actions in Rails apps}
  spec.homepage      = "https://github.com/rfwatson/routing_report"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'terminal-table', '~> 1.8'
  spec.add_dependency 'activesupport', '~> 4'
  spec.add_dependency 'unicode'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'byebug', '~> 9'
end
