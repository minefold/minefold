class TarGz
  attr_reader :options
  
  def self.new options = {}
    if RUBY_PLATFORM =~ /darwin/i
      OSX.new options
    elsif RUBY_PLATFORM =~ /linux/i
      Linux.new options
    else
      raise "Windows!? WTF!"
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