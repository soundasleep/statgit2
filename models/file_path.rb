class FilePath < ActiveRecord::Base
  belongs_to :repository

  # TODO add validation for nulls
end
