class Author < ActiveRecord::Base
  belongs_to :repository

  has_many :commits, dependent: :destroy
end
