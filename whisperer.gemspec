# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whisperer/version'

Gem::Specification.new do |spec|
  spec.name          = 'whisperer'
  spec.version       = Whisperer::VERSION
  spec.authors       = ['Dmitriy Nesteryuk']
  spec.email         = ['nesterukd@gmail.com']
  spec.description   = %q{Generate HTTP responses for VCR from structures defined by FactoryGirl}
  spec.summary       = %q{Do you hate fixtures? I do as well. The purpose of this library is to make your life much easier when your application works with external API and you have to create a lot of VCR fixtures.}
  spec.homepage      = 'http://github.com/dnesteryuk/whisperer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'factory_girl', '~> 4.3.0'
  spec.add_dependency 'vcr',          '~> 2.8.0'
  spec.add_dependency 'virtus',       '~> 1.0.1'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'rainbow'
  spec.add_dependency 'thread_safe'
end
