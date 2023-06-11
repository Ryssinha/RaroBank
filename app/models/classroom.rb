class Classroom < ApplicationRecord
  has_many :administrators
  has_many :users, through: :administrators

  validates :name, presence: true
end
