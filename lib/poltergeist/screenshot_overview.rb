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

    # @override
    def visit(*args)
      super
      make_screenshot(args.first)
    end

    # @override
    def click_button(*args)
      super
      make_screenshot(args.first)
    end

    # @override
    def click_link(*args)
      super
      make_screenshot(args.first)
    end

    private

    def make_screenshot(argument)
      if self.example.metadata[:js] || self.example.metadata[:screenshot]
        filename = Manager.instance.add_image_from_rspec(argument, self.example, current_path)
        page.driver.render(Rails.root.join(filename).to_s,full: true)
      end
    end

  end
end
