# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

class RetrieveSaltAdapter
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  MINIMUM_SALT_LENGTH = 20

  def call
    if salt.nil?
      Failure('Environment variable OBFUSCATION_URL_SECRET must be set')
    elsif salt.length < MINIMUM_SALT_LENGTH
      Failure('Environment variable OBFUSCATION_URL_SECRET must have length ' \
              "equal or bigger than #{MINIMUM_SALT_LENGTH}")
    else
      Success(salt)
    end
  end

  private

  def salt
    ENV['OBFUSCATION_URL_SECRET']
  end
end
