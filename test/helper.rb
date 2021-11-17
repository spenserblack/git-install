# frozen_string_literal: true

if ENV['CI'] == 'true'
  require 'simplecov'
  SimpleCov.start if ENV['CI'] == 'true'

  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

class Helper
  def self.set_env(key, new_value)
    old_value = ENV[key]
    ENV[key] = new_value
    yield
  ensure
    ENV[key] = old_value
  end
end
