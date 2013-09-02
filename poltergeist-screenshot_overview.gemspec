# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poltergeist/screenshot_overview/version'

Gem::Specification.new do |spec|
  spec.name          = "poltergeist-screenshot_overview"
  spec.version       = "0.1.6"
  spec.authors       = ["Stefan Wienert"]
  spec.email         = ["stefan.wienert@pludoni.de"]
  spec.description   = %q{hooks into Capybara poltergeist to automatically make screenshots after each click}
  spec.summary       = %q{Useful for running in Continuos integration server, so the designer can look up, after recent design changes, if anything broke. One get's a brief overview over the application wide style renderings (on Chrome).}
  spec.homepage      = "https://github.com/zealot128/poltergeist-screenshot_overview"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "poltergeist"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
