
module Gremlin
  module PersistenceAdapters
    class Abstract
      def pagination?
        false
      end

      def filtering_by
        []
      end

      def ordering_by
        []
      end

      # @option options [Integer] page index of the page (starting at 0)
      # @option options [Integer] per_page the number of the items on page
      # @option options [Symbol] order_by name of the column to use for ordering
      # @option options [true, false] desc set to true if order should be descending
      # @option options [Hash{ Symbol => Object,Array<object> }] filters hash represents
      #   set of allowed values for a given key representing column
      def find_jobs(options = {})
        raise NotImplementedError
      end

      def load_jobs(job_id)
        raise NotImplementedError
      end

      def save_jobs(job_id, value)
        raise NotImplementedError
      end
      # for debug purposes
      def to_hash
        raise NotImplementedError
      end
    end
  end
end