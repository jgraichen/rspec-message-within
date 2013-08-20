require 'rspec/message/within/version'
require 'rspec/mocks'

module RSpec
  module MessageWithin
    def self.until(within_time)
      if within_time && within_time > 0.0
        time = Time.now + within_time
        while time > Time.now
          break if yield
          sleep 0
        end
      end
    end
  end
end

module RSpec
  module Mocks
    class MessageExpectation
      alias_method :orig_verify_messages_received, :verify_messages_received
      def verify_messages_received
        MessageWithin.until(@within_time || 0) do
          expected_messages_received? and !negative?
        end

        orig_verify_messages_received
      end

      def within(time)
        @within_time = time
        self
      end
    end

    module Matchers
      class Receive
        def within(*args, &block)
          @recorded_customizations << ::RSpec::Mocks::Matchers::Receive::Customization.new(:within, args, block)
          self
        end

        def seconds
          self
        end
      end
    end

    module AnyInstance
      class ExpectationChain
        alias_method :orig_expectation_fulfilled?, :expectation_fulfilled?

        def expectation_fulfilled?
          RSpec::MessageWithin.until(@within_time || 0) do
            orig_expectation_fulfilled?
          end

          orig_expectation_fulfilled?
        end

        def within(time)
          @within_time = time
          self
        end
      end
    end
  end
end
