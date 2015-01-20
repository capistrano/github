# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/github/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-github"
  spec.version       = Capistrano::Github::VERSION
  spec.authors       = ["Kir Shatrov", 'Michal Cichra']
  spec.email         = ["shatrov@me.com", 'michal@3scale.net']
  spec.summary       = %q{Integrates Capistrano with Github Deployments API}
  spec.homepage      = "http://github.com/capistrano/github"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", "~> 3.1"
  spec.add_dependency "octokit", ">= 3.0", "< 4.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '~> 3.1'
end
