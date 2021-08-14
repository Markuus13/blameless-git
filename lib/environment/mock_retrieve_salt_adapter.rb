# frozen_string_literal: true

require 'dry/monads'

class MockRetrieveSaltAdapter
  include Dry::Monads[:result]

  MINIMUM_SALT_LENGTH = 3

  def initialize(salt: 'abcdefghijklmnopqrstuvwxyz')
    @salt = salt
  end

  def call
    if @salt.nil?
      Failure('Environment variable OBFUSCATION_URL_SECRET must be set')
    elsif @salt.length < MINIMUM_SALT_LENGTH
      Failure('Environment variable OBFUSCATION_URL_SECRET must have length ' \
              "equal or bigger than #{MINIMUM_SALT_LENGTH}")
    else
      Success(@salt)
    end
  end
end
