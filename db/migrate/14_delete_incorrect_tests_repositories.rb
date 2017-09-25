class DeleteIncorrectTestsRepositories < ActiveRecord::Migration
  def change
    # before issue #28, incorrect repository stats were being generated;
    # we need to regenerate them
    Repository.where.not(parent_repository_id: nil).destroy_all
  end
end
