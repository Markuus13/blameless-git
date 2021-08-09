# frozen_string_literal: true

require_relative '../../../lib/domain/use_cases/create_obfuscated_git_repository'

RSpec.describe CreateObfuscatedGitRepository do
  let(:in_memory_git_repo_repository) { MockGitRepoRepository.new }

  before { in_memory_git_repo_repository.destroy_all }

  subject(:create_obfuscated_git_repository) do
    described_class.new(git_repo_repository: in_memory_git_repo_repository)
  end

  context 'when url is accepted based on our providers' do
    let(:git_repository_url) { 'https://github.com/sirius-black/marauders-map' }

    it 'succeeds' do
      result = create_obfuscated_git_repository.call(git_repository_url)
      expect(result.success?).to eq(true)
    end

    it 'returns an created obfuscated git repository' do
      result = create_obfuscated_git_repository.call(git_repository_url)
      git_repository = in_memory_git_repo_repository.all.last
      expect(result.value!).to eq(
        id: git_repository.id,
        original_url: git_repository.original_url,
        obfuscated_url: git_repository.obfuscated_url,
        name: git_repository.name,
        owner_name: git_repository.owner_name,
        provider_name: git_repository.provider_name
      )
    end
  end
end
