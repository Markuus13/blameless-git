# frozen_string_literal: true

require_relative '../../lib/domain/use_cases/create_obfuscated_git_repository'
require_relative '../../lib/database/mock_git_repo_repository'
require_relative '../../lib/environment/mock_retrieve_salt_adapter'

RSpec.describe CreateObfuscatedGitRepository do
  context 'when given url is a valid git repository url' do
    let(:in_memory_git_repo_repository) { MockGitRepoRepository.new }
    let(:mock_retrieve_salt_adapter) { MockRetrieveSaltAdapter.new }

    subject(:create_obfuscated_git_repository) do
      described_class.new(
        git_repo_repository: in_memory_git_repo_repository,
        retrieve_salt_adapter: mock_retrieve_salt_adapter
      )
    end

    let(:git_repository_url) { 'https://github.com/sirius-black/marauders-map' }

    after { in_memory_git_repo_repository.destroy_all }

    it 'succeeds' do
      result = create_obfuscated_git_repository.call(git_repository_url)

      expect(result.success?).to eq(true)
    end

    it 'returns a hash of the created git repository' do
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

    it 'persists a git repository in database' do
      expect { create_obfuscated_git_repository.call(git_repository_url) }
        .to change { in_memory_git_repo_repository.all.size }.from(0).to(1)
    end
  end

  describe 'failures' do
    context 'when given url is not a valid git repository url' do
      let(:in_memory_git_repo_repository) { MockGitRepoRepository.new }
      let(:mock_retrieve_salt_adapter) { MockRetrieveSaltAdapter.new }

      subject(:create_obfuscated_git_repository) do
        described_class.new(
          git_repo_repository: in_memory_git_repo_repository,
          retrieve_salt_adapter: mock_retrieve_salt_adapter
        )
      end

      let(:not_a_git_repository_url) { 'https://github.com' }

      after { in_memory_git_repo_repository.destroy_all }

      it 'fails' do
        result = create_obfuscated_git_repository.call(not_a_git_repository_url)
        expect(result.failure?).to eq(true)
      end

      it 'returns an error message' do
        result = create_obfuscated_git_repository.call(not_a_git_repository_url)
        expect(result.failure).to be_a(String)
      end

      it 'does not persist a git repository in database' do
        expect { create_obfuscated_git_repository.call(not_a_git_repository_url) }
          .to_not(change { in_memory_git_repo_repository.all.size })
      end
    end

    context 'when already exists a persisted git repository for given url' do
      let(:in_memory_git_repo_repository) { MockGitRepoRepository.new }
      let(:mock_retrieve_salt_adapter) { MockRetrieveSaltAdapter.new }

      subject(:create_obfuscated_git_repository) do
        described_class.new(
          git_repo_repository: in_memory_git_repo_repository,
          retrieve_salt_adapter: mock_retrieve_salt_adapter
        )
      end

      subject(:create_obfuscated_git_repository) do
        described_class.new(
          git_repo_repository: in_memory_git_repo_repository,
          obfuscate_url_service: obfuscate_url_service
        )
      end

      let(:provider) { 'github' }
      let(:owner) { 'sirius-black' }
      let(:repo_name) { 'marauders-map' }
      let(:git_repository_url) { "https://#{provider}.com/#{owner}/#{repo_name}" }

      before do
        git_repository = GitRepository.new(
          original_url: git_repository_url,
          obfuscated_url: '3URM7qomHSvNtd1VWZQl2LsjDHmqIMAdDv4qwx7ZW4s=',
          name: repo_name,
          owner_name: owner,
          provider_name: provider
        )
        in_memory_git_repo_repository.save(git_repository)
      end

      after { in_memory_git_repo_repository.destroy_all }

      xit 'fails' do
        result = create_obfuscated_git_repository.call(git_repository_url)
        expect(result.failure?).to eq(true)
      end

      xit 'returns an error message' do
        result = create_obfuscated_git_repository.call(git_repository_url)
        expect(result.failure).to be_a(String)
      end

      xit 'does not persist a git repository in database' do
        expect { create_obfuscated_git_repository.call(git_repository_url) }
          .to_not(change { in_memory_git_repo_repository.all.size })
      end
    end
  end
end
