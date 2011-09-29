class Archive
  attr_reader :options

  def self.new(*args)
    case RUBY_PLATFORM
    when /darwin/i
      OSX.new(*args)
    when /linux/i
      Linux.new(*args)
    end
  end

  class Base
    attr_reader :options
    def initialize options = {}
      @options = options
    end

    def run_command cmd
      `#{cmd}`
    end

    def archive path, output_file, options = {}
      run_command "tar #{option_string(options)} -czf '#{output_file}' '#{path}'"
    end

    def extract archive_file, options = {}
      run_command "tar #{option_string(options)} -xzf '#{archive_file}'"
    end
  end

  class OSX < Base
    def option_string options
      options.map{|k,v| "--#{k} '#{v}'"}.join(" ")
    end
  end

  class Linux < Base
    def option_string options
      options.map{|k,v| "--#{k}='#{v}'"}.join(" ")
    end
  end
end