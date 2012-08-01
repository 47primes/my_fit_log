module Shoulda # :nodoc:
  module Matchers
    module ActionController # :nodoc:

      # Ensures a controller responded with expected 'response' location header.
      #
      # Example:
      #
      #   it { should respond_with_location(@user)  }
      #   it { should respond_with_location(posts_url)  }
      def respond_with_location(location)
        RespondWithLocation.new(location)
      end

      class RespondWithLocation # :nodoc:

        def initialize(location)
          @location = location
        end

        def matches?(controller)
          @controller = controller
          correct_location?
        end

        def failure_message
          "Expected #{expectation}"
        end

        def negative_failure_message
          "Did not expect #{expectation}"
        end

        def description
          "respond with location of #{@location}"
        end

        protected

        def correct_location?
          controller_location == @location
        end

        def controller_location
          @controller.location
        end

        def expectation
          "response location to be #{@location}, but was #{controller_location}"
        end
      end
    end
  end
end
