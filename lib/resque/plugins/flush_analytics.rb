module Resque
  module Plugins
    module FlushAnalytics

      def before_perform_flush_analytics(*args)
        Analytics.init(secret: ENV['SEGMENT_SECRET'])
      end

      def after_perform_flush_analytics(*args)
        Analytics.flush
      end

      def on_failure_flush_analytics(e, *args)
        Analytics.flush
      end

    end
  end
end
