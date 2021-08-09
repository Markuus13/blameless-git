# frozen_string_literal: true

class GitRepository
  attr_accessor :id, :original_url, :obfuscated_url, :name, :owner_name, :provider_name

  def initialize(
    original_url: nil,
    obfuscated_url: nil,
    name: nil,
    owner_name: nil,
    provider_name: nil
  )
    @original_url = original_url
    @obfuscated_url = obfuscated_url
    @name = name
    @owner_name = owner_name
    @provider_name = provider_name
  end
end
