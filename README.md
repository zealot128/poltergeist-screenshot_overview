# Poltergeist::ScreenshotOverview

Hooks into Capybara poltergeist to automatically make screenshots after each click. Until now, only rspec supported. (Different test environments should be easy to plug in).


## Motivation

Sometimes we ran into problems:
* Some recent design changes broke something on a completly different site.
*

We run this on the Continuos Integration server, so we get an up2date overview of most application's views rendered on a full blown Chromium (thx to poltergeist and Phantomjs).

## Usage

Add this line to your application's Gemfile:

    group :test do
      gem 'poltergeist-screenshot_overview'
    end


As the gem's name suggest, poltergeist and so Capybara is required.

### Rspec

puts this in your spec_helper.rb somewhere below application loading:

    require "poltergeist/screenshot_overview/rspec"

Run your feature specs. Every visit, click_button and click_link will create a screenshot into public/cockpit.

After test run, visit localhost:3000/cockpit/index.html in your browser to view the screenshots.

NOTE: only feature specs with ``js: true`` will be run, to avoid problems with non-capable drivers.

## Configuration

Change setting with:

    Poltergeist::ScreenshotOverview.target_directory = 'public/cockpit'
    Poltergeist::ScreenshotOverview.layout = 'GEM_DIR/templates/layout.erb'
    Poltergeist::ScreenshotOverview.template = 'GEM_DIR/templates/screenshot.erb'

NOTE: before test execution, all jpg's in target_directory are deleted.

To render different Styles

## Contributing

Possibly needed features
* Other than rspec's adapters (mini-test)
* Could run with different Browsers that support screenshoting, but so far only Poltergeist implemented
* UI
  * general styling
  * some kind of TOC, affix or stuff
  * line numbers, file open links

