# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/message/within/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec-message-within'
  spec.version       = Rspec::Message::Within::VERSION
  spec.authors       = ['Jan Graichen']
  spec.email         = %w(jg@altimos.de)
  spec.description   = %q{expect(object).to receive(:message).within(:some).seconds}
  spec.summary       = %q{expect(object).to receive(:message).within(:some).seconds}
  spec.homepage      = 'https://github.com/jgraichen/rspec-message-within'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_dependency 'rspec-mocks', '~> 2.14.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14.0'
end
