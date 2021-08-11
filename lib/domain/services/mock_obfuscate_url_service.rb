# frozen_string_literal: true

require 'dry/monads'

class MockObfuscateUrlService
  include Dry::Monads[:result]

  def initialize(failure: false)
    @failure = failure
  end

  def call(repository_url)
    return Failure('Known failure') if @failure

    Success("obfuscated-#{repository_url}")
  end
end
