# frozen_string_literal: true

require_relative '../../../lib/domain/services/extract_attributes_from_git_url'

RSpec.describe ExtractAttributesFromGitUrl do
  subject(:extract_attributes_from_git_url) { described_class.new }

  let(:git_repository_url) { 'https://github.com/Markuus13/CleanFoodJava' }

  it 'succeeds' do
    result = extract_attributes_from_git_url.call(git_repository_url)
    expect(result.success?).to be(true)
  end

  it 'returns a hash with extracted data' do
    result = extract_attributes_from_git_url.call(git_repository_url)
    expect(result.value!).to eq(
      original_url: git_repository_url,
      provider_name: 'github',
      owner_name: 'Markuus13',
      name: 'CleanFoodJava'
    )
  end

  describe 'validations' do
    context 'when url is not a valid git repository' do
      let(:invalid_git_repository_url) { 'https://google.com.br' }

      it 'fails' do
        result = extract_attributes_from_git_url.call(invalid_git_repository_url)
        expect(result.failure?).to be(true)
      end

      it 'returns a error message' do
        result = extract_attributes_from_git_url.call(invalid_git_repository_url)
        expect(result.failure).to eq('URL does not match a known git repository')
      end
    end
  end
end
