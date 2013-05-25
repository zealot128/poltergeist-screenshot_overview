require "poltergeist/screenshot_overview"
require "poltergeist/screenshot_overview/manager"
RSpec.configure do |config|
  config.before(:suite) do
    Poltergeist::ScreenshotOverview::Manager.instance.start
  end
  config.after(:suite) do
    Poltergeist::ScreenshotOverview::Manager.instance.generate_html
  end

  config.include Poltergeist::ScreenshotOverview, :type => :feature, :js => true

end
