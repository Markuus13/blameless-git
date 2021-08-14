# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

require_relative '../../database/mock_git_repo_repository'
require_relative '../../environment/retrieve_salt_adapter'
require_relative '../entities/git_repository'
require_relative '../services/extract_attributes_from_git_url_service'
require_relative '../services/obfuscate_url_service'

class CreateObfuscatedGitRepository
  include Dry::Monads[:result, :try]
  include Dry::Monads::Do.for(:call)

  def initialize(
    git_repo_repository: MockGitRepoRepository.new,
    retrieve_salt_adapter: RetrieveSaltAdapter.new
  )
    @git_repo_repository = git_repo_repository
    @retrieve_salt_adapter = retrieve_salt_adapter
  end

  def call(git_repository_url)
    extracted_attributes = yield ExtractAttributesFromGitUrlService.new.call(git_repository_url)
    obfuscated_url = yield ObfuscateUrlService.new(
      retrieve_salt_adapter: @retrieve_salt_adapter
    ).call(git_repository_url)
    git_repository_attributes = extracted_attributes.merge(obfuscated_url: obfuscated_url)
    git_repository = yield create_obfuscated_repository(git_repository_attributes)
    Success(adapt_attributes_response(git_repository))
  end

  private

  def adapt_attributes_response(git_repository)
    {
      id: git_repository.id,
      original_url: git_repository.original_url,
      obfuscated_url: git_repository.obfuscated_url,
      name: git_repository.name,
      owner_name: git_repository.owner_name,
      provider_name: git_repository.provider_name
    }
  end

  def create_obfuscated_repository(git_repository_attributes)
    Try[NoMemoryError] do
      git_repository = GitRepository.new(**git_repository_attributes)
      @git_repo_repository.save(git_repository)
    end
  end
end
