# frozen_string_literal: true

require_relative '../../lib/database/mock_git_repo_repository'

RSpec.describe MockGitRepoRepository do
  subject(:mock_git_repo_repository) { described_class.new }

  describe 'interface' do
    it { is_expected.to respond_to(:all).with(0).arguments }
    it { is_expected.to respond_to(:find).with(1).argument }
    it { is_expected.to respond_to(:save).with(1).argument }
  end

  describe '#all' do
    after { mock_git_repo_repository.destroy_all }

    context 'when no git repositories were saved' do
      it 'returns an empty array' do
        expect(mock_git_repo_repository.all).to eq([])
      end
    end

    context 'when exists saved git repositories' do
      it 'returns all git repositories' do
        hanami_repository = GitRepository.new(original_url: 'https://github.com/hanami/hanami')
        grape_repository = GitRepository.new(original_url: 'https://github.com/ruby-grape/grape')
        mock_git_repo_repository.save(hanami_repository)
        mock_git_repo_repository.save(grape_repository)

        expect(mock_git_repo_repository.all).to match_array([hanami_repository, grape_repository])
      end
    end
  end

  describe '#find' do
    after { mock_git_repo_repository.destroy_all }

    context 'when id is not from a saved git repository' do
      it 'returns nil' do
        result = mock_git_repo_repository.find(1)

        expect(result).to eq(nil)
      end
    end

    context 'when id is from a saved git repository' do
      it 'returns a git repository' do
        hanami_repository = GitRepository.new(original_url: 'https://github.com/hanami/hanami')
        git_repository = mock_git_repo_repository.save(hanami_repository)

        result = mock_git_repo_repository.find(git_repository.id)

        expect(result).to eq(git_repository)
      end
    end
  end

  describe '#save' do
    after { mock_git_repo_repository.destroy_all }

    context 'when a git repository with given url does not exist' do
      it 'creates a new one' do
        hanami_repository = GitRepository.new(original_url: 'https://github.com/hanami/hanami')

        expect { mock_git_repo_repository.save(hanami_repository) }
          .to change { mock_git_repo_repository.all.size }.from(0).to(1)
      end

      it 'returns the created git repository with an id' do
        hanami_repository = GitRepository.new(original_url: 'https://github.com/hanami/hanami')

        result = mock_git_repo_repository.save(hanami_repository)

        expect(result).to be_a(GitRepository)
        expect(result.id).to_not be(nil)
      end
    end

    context 'when id is from a saved git repository' do
      it 'does not create a new one' do
        git_repository = GitRepository.new(original_url: 'https://github.com/hanami/lotus')
        mock_git_repo_repository.save(git_repository)
        git_repository.name = 'hanami'

        expect { mock_git_repo_repository.save(git_repository) }
          .to_not(change { mock_git_repo_repository.all.size })
      end

      it 'updates the saved git repository with new values' do
        git_repository = GitRepository.new(original_url: 'https://github.com/lotus/lotus')
        mock_git_repo_repository.save(git_repository)
        git_repository.name = 'hanami'

        result = mock_git_repo_repository.save(git_repository)

        expect(result.name).to eq(git_repository.name)
      end
    end
  end

  describe '#destroy_all' do
    after { mock_git_repo_repository.destroy_all }

    context 'when no git repositories were saved' do
      it 'changes nothing' do
        expect { mock_git_repo_repository.destroy_all }
          .to_not(change { mock_git_repo_repository.all.size })
      end
    end

    context 'when exists saved git repositories' do
      it 'deletes all saved git repositories' do
        hanami_repository = GitRepository.new(original_url: 'https://github.com/hanami/hanami')
        grape_repository = GitRepository.new(original_url: 'https://github.com/ruby-grape/grape')
        mock_git_repo_repository.save(hanami_repository)
        mock_git_repo_repository.save(grape_repository)

        expect { mock_git_repo_repository.destroy_all }
          .to change { mock_git_repo_repository.all.size }.from(2).to(0)
      end
    end
  end
end
