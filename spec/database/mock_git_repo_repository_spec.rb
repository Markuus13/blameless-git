# frozen_string_literal: true

require_relative '../../lib/database/mock_git_repo_repository'

RSpec.describe MockGitRepoRepository do
  subject(:mock_git_repo_repository) { described_class.new }

  describe 'interface' do
    it { is_expected.to respond_to(:all).with(0).arguments }
    it { is_expected.to respond_to(:find).with(1).argument }
    it { is_expected.to respond_to(:save).with(1).argument }
  end
end
