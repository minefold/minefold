require 'scrolls'

module Resque
  module Plugins
    module Logging

      def before_perform_setup_logging(*args)
        Scrolls.time_unit = 'ms'
        Scrolls.global_context(
          deploy: Rails.env,
          ns: self.name
        )
      end

      def around_perform_log(*args)
        Scrolls.log(fn: 'perform') do
          yield
        end
      end

    end
  end
end
