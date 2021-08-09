# frozen_string_literal: true

if ENV['CI']
  require 'codecov'
  SimpleCov.start do
    add_filter(/spec/)
  end

  require 'simplecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
