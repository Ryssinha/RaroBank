class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :cpf, length: { is: 11 }
end
