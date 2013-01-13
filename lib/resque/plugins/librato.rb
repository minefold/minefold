module Resque
  module Plugins
    module Librato

      def after_perform_flush_librato(*args)
        ::Librato::Rails.flush
      end

    end
  end
end
