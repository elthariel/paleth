# config.ru
require 'bundler'
Bundler.require(:default, :development)

sprockets_env = Opal::RSpec::SprocketsEnvironment.new
run Opal::Server.new(sprockets: sprockets_env) { |s|
  s.main = 'opal/rspec/sprockets_runner'
  s.append_path 'spec'
  s.append_path 'vendor/assets/javascripts'
  s.debug = false
}
