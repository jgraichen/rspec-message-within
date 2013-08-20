require 'spec_helper'

class Reciv
  def message; end
end

describe Rspec::Message::Within do
  let(:obj) { double }

  describe '#within' do
    it 'should allow to time-box an asynchronous method call' do
      expect(obj).to receive(:message).within(10).seconds

      Thread.new do
        sleep 1
        obj.message
      end
    end

    it 'any-instance' do
      expect_any_instance_of(Reciv).to receive(:message).within(10).seconds

      Thread.new do
        sleep 1
        Reciv.new.message
      end
    end

    it 'should fail message expectation after timeout' do
      expect(obj).to_not receive(:message).within(1).seconds

      Thread.new do
        sleep 0.2
        obj.message
      end
    end
  end
end
