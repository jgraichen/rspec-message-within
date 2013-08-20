require 'rspec/message/within/version'
require 'rspec/mocks'

module RSpec
  module Message
    module Within

      def self.until(within_time)
        if within_time && within_time > 0.0
          time = Time.now + within_time
          while time > Time.now
            break if yield
            sleep 0
          end
        end
      end

      module MessageExpectationPatch
        def self.included(base)
          # Seems to not work. Why?
          base.send :include, InstanceMethods

          base.send :alias_method, :orig_verify_messages_received, :verify_messages_received
          base.send :undef_method, :verify_messages_received
          base.send :define_method, :verify_messages_received, InstanceMethods.instance_method(:verify_messages_received)
        end

        module InstanceMethods
          def verify_messages_received
            Within.until(@within_time || 0) do
              expected_messages_received? and !negative?
            end

            orig_verify_messages_received
          end

          def within(time)
            @within_time = time
            self
          end
        end
      end

      module ReceivePatch
        def self.included(base)
          base.send :include, InstanceMethods
        end

        module InstanceMethods
          def within(*args, &block)
            @recorded_customizations << ::RSpec::Mocks::Matchers::Receive::Customization.new(:within, args, block)
            self
          end
          def seconds
            self
          end
        end
      end

      module ExpectationChainPatch
        def self.included(base)
          base.send :alias_method, :orig_expectation_fulfilled?, :expectation_fulfilled?
          base.send :undef_method, :expectation_fulfilled?
          base.send :define_method, :expectation_fulfilled?, InstanceMethods.instance_method(:expectation_fulfilled?)
        end

        module InstanceMethods
          def expectation_fulfilled?
            Within.until(@within_time || 0) do
              orig_expectation_fulfilled?
            end

            orig_expectation_fulfilled?
          end
        end
      end

      module ChainPatch
        def within(time)
          @within_time = time
          self
        end
      end

      ::RSpec::Mocks::MessageExpectation.send :include, MessageExpectationPatch
      ::RSpec::Mocks::AnyInstance::Chain.send :include, ChainPatch
      ::RSpec::Mocks::AnyInstance::ExpectationChain.send :include, ExpectationChainPatch
      ::RSpec::Mocks::Matchers::Receive.send :include, ReceivePatch
    end
  end
end
