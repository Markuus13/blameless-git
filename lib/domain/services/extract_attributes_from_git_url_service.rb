require 'dry/monads'

require_relative '../constants'

class ExtractAttributesFromGitUrlService
  def call(git_repository_url)
    url_matches = original_url.match(Constants::PROVIDERS_URL_FORMAT)
    git_repository_attributes = split_git_repository_data(url_matches)
    validate_attributes(git_repository_attributes)
  end

  private

  def split_git_repository_data(url_matches)
    return {} if url_matches.nil?

    {
      provider_name: url_matches[0],
      owner_name: url_matches[1],
      name: url_matches[2],
    }
  end

  def validate_attributes(git_repository_attributes)
    if git_repository_attributes.empty?
      return Failure('URL does not match a known git repository')
    elsif git_repository_attributes.has_value?(nil)
      return Failure('Following fields could not be extracted:')
    else
      return Success(result)
    end
  end
end
