require "erb"
require "ostruct"
module Poltergeist::ScreenshotOverview
  class Manager
    include Singleton

    def start
      Dir[File.join Poltergeist::ScreenshotOverview.target_directory, "*jpg"].each do |file|
        File.unlink file
      end
      @files = []
    end

    # adds image_path and metadata to our list, returns a full path where the
    # Engine should put the screenshot in
    def add_image_from_rspec(argument, example, url_path)
      filename = [example.description, argument, Digest::MD5.hexdigest("foo")[0..6] ].join(" ").gsub(/\W+/,"_") + ".jpg"

      full_name = File.join(Poltergeist::ScreenshotOverview.target_directory, filename )
      FileUtils.mkdir_p Poltergeist::ScreenshotOverview.target_directory
      describe = example.metadata[:example_group][:description_args]
      @files << {
        :url => url_path,
        :argument => argument,
        :local_image => filename,
        :full_path => full_name,
        :test_file => example.file_path,
        :describe_descriptions => describe,
        :example_description => example.description
      }
      full_name
    end

    def generate_html
      title = "Screenshot Overview (#{Time.now.to_s})"
      template = ERB.new File.new(Poltergeist::ScreenshotOverview.layout).read, nil, "%"
      html = template.result(binding)
      File.open( File.join(Poltergeist::ScreenshotOverview.target_directory, "index.html"), "w+") { |f|
        f.write html }
    end


    def rendered_screenshots
      template = ERB.new File.read(Poltergeist::ScreenshotOverview.template), nil, "%"
      @files.map do |file|
        namespace = OpenStruct.new(file)
        template.result(namespace.instance_eval { binding })
      end.join
    end

  end
end
