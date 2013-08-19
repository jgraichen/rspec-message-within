# Rspec::Message::Within

Allow to specify a timeout for message expectations. Useful for testing asynchronous or threaded code.

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-message-within'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-message-within

## Usage

```ruby
    it 'should receive message within 2 seconds' do
      expect(obj).to receive(:message).within(2).seconds

      Thread.new do
        sleep 1
        obj.message
      end
    end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
