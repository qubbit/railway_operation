module RailwayOperation
  module Operator
    class FailStep < StandardError; end
    class HaltStep < StandardError; end
    class HaltOperation < StandardError; end
    class FailOperation < StandardError; end

    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods
      def track(track_index, method, failure: nil, success: nil)
        @track ||= []
        @step_count ||= 0

        @track[track_index] ||= []
        @track[track_index][@step_count] = {
          method: method,
          success: success,
          failure: failure
        }

        @step_count += 1
        @track
      end

      def tracks
        @track
      end

      def run(argument = Result.new)
        # Find the first track with a step defined
        track_index = tracks.index { |v| !v.nil? }
        step_index = 0

        new.run(argument, track_index, step_index)
      end
    end

    module InstanceMethods
      def run(argument, track_index = 0, step_index = 0)
        @original_argument ||= argument
        return argument if step_index > last_step_index

        # We are doing the clone early so that the new_argument
        # could be mutated in context of the operation step,
        # SwitchTrack or HaltExecution and maintain the mutations
        # to the argument thus far
        new_argument = argument.clone
        current_step = tracks[track_index][step_index]

        begin
          if current_step
            send(current_step[:method], new_argument)
            run(new_argument, current_step[:success] || track_index, step_index + 1)
          else
            run(argument, track_index, step_index + 1)
          end
        rescue FailStep
          next_track_index = current_step[:failure]
          next_track_index ||= track_index + 1

          # We pass the original argument instead of the new_argument because we
          # don't want to persist any changes that resulted from a failed step
          run(argument, next_track_index, step_index + 1)
        rescue HaltStep
          next_track_index = current_step[:success] || track_index
          run(new_argument,  next_track_index, step_index + 1)
        rescue HaltOperation
          new_argument
        rescue FailOperation
          @original_argument
        end
      end

      def fail_step!
        raise FailStep
      end

      def fail_operation!
        raise FailOperation
      end

      def halt_step!
        raise HaltStep
      end

      def halt_operation!
        raise HaltOperation
      end

      def tracks
        self.class.tracks
      end

      def last_step_index
        @lsi ||= tracks.sort_by(&:length).last.length - 1
      end
    end
  end
end