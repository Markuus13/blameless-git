# frozen_string_literal: true

require 'digest'
require 'dry/monads'
require 'dry/monads/do'

require_relative '../../../environment/retrieve_salt_adapter'

class ObfuscateUrlService
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  def initialize(retrieve_salt_adapter: RetrieveSaltService.new)
    @retrieve_salt_adapter = retrieve_salt_adapter
  end

  def call(repository_url)
    salt = yield @retrieve_salt_adapter.call
    obfuscated_url = Digest::SHA256.base64digest("#{salt}#{repository_url}")
    Success(obfuscated_url)
  end
end
