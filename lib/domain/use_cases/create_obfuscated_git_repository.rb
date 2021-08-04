require 'dry/monads'

require_relative '../../database/mock_git_repo_repository'
require_relative '../entities/git_repository'

class CreateObfuscatedGitRepository
  include Dry::Monads[:result]

  def initialize(git_repo_repository: MockGitRepoRepository.new)
    @git_repo_repository = git_repo_repository
  end

  def call(git_repository_url)
    git_repository = GitRepository.new(original_url: git_repository_url)
    git_repository.generate_hidden_url!
    git_repository = @git_repo_repository.save(git_repository)
    Success(git_repository)
  end
end
