require 'spec_helper'

describe Rspec::Message::Within do
  let(:obj) { double }

  describe '#within' do
    it 'should allow to time-box an asynchronous method call' do
      expect(obj).to receive(:message).within(2).seconds

      Thread.new do
        obj.message
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
