require "erb"
require "ostruct"
module Poltergeist::ScreenshotOverview
  class ScreenshotGroup
    attr_accessor :screenshots, :file_name

    def initialize(file,screenshots)
      @file_name = file
      @screenshots = screenshots
    end

    def to_id
      file_name.gsub(/\W+/, "-").gsub(/^-/, "")
    end
  end

  class Screenshot
    ATTR = :url, :argument, :local_image, :full_path, :group_description, :example_description, :file_with_line
    attr_accessor(*ATTR)
    def initialize(opts={})
      opts.each do |k,v|
        self.send("#{k}=", v)
      end
    end

    def to_hash
      Hash[
        ATTR.map{|k|[k, self.send(k)]}
      ]
    end

    def line_number
      file_with_line.split(":")[1].to_i rescue 0
    end

    def full_test_path
      file_with_line.split(":")[0]
    end

    def snippet
      File.read(full_test_path).lines[ line_number - 3, 5].join
    end

    def test_file
      full_test_path.gsub(Dir.pwd, "").gsub("spec/features/","")
    end

    def render
      template = ERB.new File.read(Poltergeist::ScreenshotOverview.template), nil, "%"
      template.result(binding)
    end
  end

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
      blob = caller.find{|i| i[ example.file_path.gsub(/:\d*|^\./,"") ]}
      file_with_line = blob.split(":")[0,2].join(":")

      filename = [example.description, argument, file_with_line, SecureRandom.hex(6) ].join(" ").gsub(/\W+/,"_") + ".jpg"
      full_name = File.join(Poltergeist::ScreenshotOverview.target_directory, filename )
      FileUtils.mkdir_p Poltergeist::ScreenshotOverview.target_directory
      describe = example.metadata[:example_group][:description_args]
      @files << Screenshot.new({
        :url                 => url_path,
        :argument            => argument,
        :local_image         => filename,
        :full_path           => full_name,
        :group_description   => describe,
        :example_description => example.description,
        :file_with_line      => file_with_line
      })
      full_name
    end

    def generate_html
      title = title = "Screenshot Overview (#{Time.now.to_s})"
      template = ERB.new File.new(Poltergeist::ScreenshotOverview.layout).read, nil, "%"
      html = template.result(binding)
      File.open( File.join(Poltergeist::ScreenshotOverview.target_directory, "index.html"), "w+") { |f|
        f.write html }
    end


    def groups
      @files.
        group_by{ |screenshot| screenshot.test_file}.
        map{|file,screenshots| ScreenshotGroup.new(file,screenshots.sort_by{|s| s.file_with_line }) }
    end

  end
end
