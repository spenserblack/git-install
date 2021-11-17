# frozen_string_literal: true

if ENV['CI'] == 'true'
  require 'simplecov'
  SimpleCov.start if ENV['CI'] == 'true'

  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
