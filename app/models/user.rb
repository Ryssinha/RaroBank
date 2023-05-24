class User < ApplicationRecord
  validates :nome, presence: true
  validates :cpf, presence: true, uniqueness: true
end
