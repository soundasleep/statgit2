class Repository < ActiveRecord::Base
  has_many :commits, dependent: :destroy
end
