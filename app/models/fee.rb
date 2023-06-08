class Fee < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :value, presence: true, inclusion: { in: 0..100, message: "Deve estar entre 0 e 1000" }
  validates :latest_release, presence: true

  before_save :check_duplicate_name

  private

  def check_duplicate_name
    if Fee.exists?(name: name)
      errors.add(:name, "já está cadastrado")
      throw(:abort)
    end
  end
end
