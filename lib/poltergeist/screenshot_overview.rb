module Poltergeist
end
require "poltergeist/screenshot_overview/manager"
module Poltergeist
  module ScreenshotOverview
    class << self
      attr_writer :target_directory
      attr_writer :layout
      attr_writer :template

      def target_directory
        @target_directory ||  "public/cockpit"
      end

      def layout
        @layout || File.join(File.dirname(__FILE__), "../../templates/layout.erb")
      end
      def template
        @layout || File.join(File.dirname(__FILE__), "../../templates/screenshot.erb")
      end
    end

  end
end
