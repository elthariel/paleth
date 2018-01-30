lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paleth/version'

Gem::Specification.new do |spec|
  spec.name          = 'paleth'
  spec.version       = Paleth::VERSION
  spec.authors       = ["Julien 'Lta' BALLET"]
  spec.email         = ['contact@lta.io']

  spec.summary       = %q(Opal ruby wrapper for ethereum's web3.js)
  spec.homepage      = 'github.com/elthariel/paleth'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'opal', '~> 0.11'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'opal-rspec', '~> 0.11'
end
