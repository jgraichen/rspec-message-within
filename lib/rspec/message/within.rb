require 'rspec/message/within/version'
require 'rspec/mocks'

module RSpec
  module Message
    module Within

      module ExpectationPatch
        def self.included(base)
          # Seems to not work. Why?
          base.send :include, InstanceMethods

          base.send :alias_method, :orig_verify_messages_received, :verify_messages_received
          base.send :undef_method, :verify_messages_received
          base.send :define_method, :verify_messages_received, InstanceMethods.instance_method(:verify_messages_received)
        end

        module InstanceMethods
          def verify_messages_received
            @within_time ||= nil

            if @within_time
              time = Time.now + @within_time
              while time > Time.now
                break if expected_messages_received? and !negative?
                sleep 0
              end
            end

            orig_verify_messages_received
          end

          def within(time)
            @within_time = time
            self
          end
        end
      end

      module MatcherPatch
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
    end

    ::RSpec::Mocks::MessageExpectation.send :include, Within::ExpectationPatch
    ::RSpec::Mocks::Matchers::Receive.send :include, Within::MatcherPatch
  end
end
