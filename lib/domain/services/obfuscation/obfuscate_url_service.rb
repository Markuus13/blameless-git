# frozen_string_literal: true

require 'digest'
require 'dry/monads'
require 'dry/monads/do'

require_relative 'retrieve_salt_service'

class ObfuscateUrlService
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  def initialize(retrieve_salt_service: RetrieveSaltService.new)
    @retrieve_salt_service = retrieve_salt_service
  end

  def call(repository_url)
    salt = yield @retrieve_salt_service.call
    obfuscated_url = Digest::SHA256.base64digest("#{salt}#{repository_url}")
    Success(obfuscated_url)
  end
end
