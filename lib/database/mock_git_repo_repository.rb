class MockGitRepoRepository
  @@store = []
  @@id_counter = 0

  def all
    @@store
  end

  def save(git_repository)
    index = @@store.find_index { |repo| repo.id == git_repository.id }
    if index.nil?
      id_counter += 1
      git_repository.id = id_counter
      @@store << git_repository
    else
      @@store[index] = git_repository
    end
  end

  def destroy_all
    @@store = []
  end
end