module Poltergeist::ScreenshotOverview
  module CapybaraPatch

    extend ActiveSupport::Concern
    included do

      # @override
      def visit(url)
        with_screenshot(url, page.visit(url))
      end

      # @override
      def click_button(*args)
        # page.send method, *args, &block
        with_screenshot(args.first, page.click_button(*args))
      end

      # @override
      def click_link(*args)
        with_screenshot(args.first, page.click_link(*args))
      end

      # @override
      def click_on(*args)
        with_screenshot(args.first, page.click_on(*args))
      end
    end

    private

    def with_screenshot(url, result)
      make_screenshot(url)
      result
    end

    def make_screenshot(argument)
      if defined?(RSpec.current_example)
        ex = RSpec.current_example
      else
        ex = example
      end
      if ex && (ex.metadata[:js] || ex.metadata[:screenshot])
        filename = Manager.instance.add_image_from_rspec(argument, ex, current_path)
        page.driver.render(Rails.root.join(filename).to_s, full: true)
      end
    end

  end
end
