require_relative '../../../lib/domain/use_cases/create_obfuscated_git_repository'

RSpec.describe CreateObfuscatedGitRepository do
  let(:in_memory_git_repo_repository) { MockGitRepoRepository.new }

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
      git_repository = result.value!
      expect(git_repository.id).to_not be(nil)
    end
  end
end
