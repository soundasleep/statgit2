class FileSassStylesheet < ActiveRecord::Base
  belongs_to :commit
  belongs_to :commit_file
end