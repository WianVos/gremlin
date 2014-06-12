module Gremlin
  module Mixins
    module Scheduler_mixins


      # returns a scheduler object instance
      # creates one if needed
      def scheduler

        return @scheduler if @scheduler

        @scheduler = Rufus::Scheduler.new

      end

      def schedule
        return @scheduler if @scheduler

        return scheduler

      end

      def pause
        scheduler.pause
      end

      def paused?
        scheduler.paused?
      end

      def resume
        scheduler.resume
      end



    end
  end
end