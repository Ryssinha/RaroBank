class Transfer < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  enum :status, {
    pending: 1,
    confirmed: 2
  }, scopes: true, default: :pending

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :sender, presence: true
  validate :sufficient_balance, if: :sender

  before_create :generate_token

  def execute_transfer
    sender_balance = sender.balance || Balance.new(user: sender)
    receiver_balance = receiver.balance || Balance.new(user: receiver)

    Transfer.transaction do
      sender_balance.withdraw(amount)
      receiver_balance.deposit(amount)
    end
  end

  private

  def generate_token
    self.token = rand(100000..999999)
  end

  def set_expiration
    self.expires_at = 5.minutes.from_now
  end

  def sufficient_balance
    sender_balance = sender.balance || Balance.new(user: sender)

    if amount > sender_balance.current_balance
      errors.add(:amount, "Saldo insuficiente para realizar a transferência.")
    end
  end

end
