require 'capybara'
# require 'poltergeist'
require "poltergeist/screenshot_overview"
require "poltergeist/screenshot_overview/manager"
require "poltergeist/screenshot_overview/capybara_patch"

Capybara::DSL.send(:include, Poltergeist::ScreenshotOverview::CapybaraPatch)

RSpec.configure do |config|
  config.before(:suite) do
    Poltergeist::ScreenshotOverview::Manager.instance.start
  end
  config.after(:suite) do
    Poltergeist::ScreenshotOverview::Manager.instance.generate_html
  end
end
