# frozen_string_literal: true

require_relative '../../../../../lib/domain/services/obfuscation/obfuscate_url_service'
require_relative '../../../../../lib/domain/services/obfuscation/mock_retrieve_salt_service'

RSpec.describe ObfuscateUrlService do
  subject(:obfuscate_url_service) do
    described_class.new(retrieve_salt_service: MockRetrieveSaltService.new)
  end

  let(:git_repository_url) { 'https://github.com/Markuus13/CleanFoodJava' }

  it 'succeeds' do
    result = obfuscate_url_service.call(git_repository_url)
    expect(result.success?).to be(true)
  end

  it 'returns a base64 hashed string' do
    result = obfuscate_url_service.call(git_repository_url)
    expect(result.value!).to eq('3URM7qomHSvNtd1VWZQl2LsjDHmqIMAdDv4qwx7ZW4s=')
  end
end
