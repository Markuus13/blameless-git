# frozen_string_literal: true

require_relative '../../../../../lib/domain/services/obfuscation/retrieve_salt_service'

RSpec.describe RetrieveSaltService do
  subject(:retrieve_salt_service) { described_class.new }

  after { ENV['OBFUSCATION_URL_SECRET'] = nil }

  describe 'success' do
    before do
      ENV['OBFUSCATION_URL_SECRET'] = 'abcdefghijklmnopqrstuvwyxz'
    end

    it 'succeeds' do
      result = retrieve_salt_service.call
      expect(result.success?).to be(true)
    end

    it 'returns a salt string' do
      result = retrieve_salt_service.call
      expect(result.value!).to eq(ENV['OBFUSCATION_URL_SECRET'])
    end
  end

  describe 'validations' do
    context 'when OBFUSCATION_URL_SECRET is not set' do
      before do
        ENV['OBFUSCATION_URL_SECRET'] = nil
      end

      it 'fails' do
        result = retrieve_salt_service.call
        expect(result.failure?).to be(true)
      end

      it 'returns a error message' do
        result = retrieve_salt_service.call
        expect(result.failure).to eq('Environment variable OBFUSCATION_URL_SECRET must be set')
      end
    end

    context 'when OBFUSCATION_URL_SECRET does not have a minimum length' do
      before do
        ENV['OBFUSCATION_URL_SECRET'] = '12345'
      end

      it 'fails' do
        result = retrieve_salt_service.call
        expect(result.failure?).to be(true)
      end

      it 'returns a error message' do
        result = retrieve_salt_service.call
        expect(result.failure).to eq(
          'Environment variable OBFUSCATION_URL_SECRET must have length equal ' \
          "or bigger than #{described_class::MINIMUM_SALT_LENGTH}"
        )
      end
    end
  end
end
