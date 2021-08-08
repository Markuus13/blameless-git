require 'dry/monads'

class MockObfuscateGitRepositoryUrl
  include Dry::Monads[:result]

  def call(repository_url)
    Success("obfuscated-#{repository_url}")
  end
end
