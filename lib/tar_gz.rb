require 'shellwords'

class TarGz
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

    def archive(cwd, path, output, args={})
      sh 'tar', arg_str(args), '-C', cwd, '-czf', output, path
    end

    def extract(input, args={})
      sh 'tar', arg_str(args), '-xzf', Shellwords.escape(input)
    end

  private

    def sh(*argv)
      cmd = Shellwords.join(argv)
      Rails.logger.info(cmd)
      out = `#{cmd}`
      Rails.logger.info(out)
      out
    end

  end

  class OSX < Base
    def arg_str(args)
      Shellwords.join args.map{|k,v| "--#{k} '#{Shellwords.escape(v)}'"}
    end
  end

  class Linux < Base
    def arg_str(args)
      Shellwords.join args.map{|k,v| "--#{k}='#{Shellwords.escape(v)}'"}
    end
  end
end