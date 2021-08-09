# frozen_string_literal: true

require 'dry/monads'

require_relative '../constants'

class ExtractAttributesFromGitUrl
  include Dry::Monads[:result]

  def call(repository_url)
    url_matches = repository_url.match(Constants::PROVIDERS_URL_FORMAT)
    git_repository_attributes = split_git_repository_data(url_matches)
    return Failure('URL does not match a known git repository') if git_repository_attributes.empty?

    Success(git_repository_attributes.merge(original_url: repository_url))
  end

  private

  def split_git_repository_data(url_matches)
    return {} if url_matches.nil?

    {
      provider_name: url_matches[1],
      owner_name: url_matches[2],
      name: url_matches[3]
    }
  end
end
