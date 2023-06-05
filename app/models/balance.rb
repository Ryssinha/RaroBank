class Balance < ApplicationRecord
  belongs_to :user

  validates :withdrawn, :balance_deposited, :current_balance, presence: true
  validates :withdrawn, :balance_deposited, :current_balance, numericality: { greater_than_or_equal_to: 0 }
  validates :user, presence: true

  scope :positive_balance, -> { where("current_balance > 0") }
  scope :by_user, ->(user) { where(user: user) }

  after_save :calculate_current_balance

  def calculate_current_balance
    self.current_balance = balance_deposited - withdrawn
  end

  private

  def current_balance_calculated?
    current_balance_calculated || false
  end


  private

  def self.positive_balance
    where('current_balance > 0')
  end
end

