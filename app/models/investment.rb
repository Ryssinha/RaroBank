class Investment < ApplicationRecord
    belongs_to :user
    belongs_to :product
  
    validates :user, presence: true
    validates :product, presence: true

    after_save :update_value_to_redeem

    private

    def update_value_to_redeem
      fee_value = product.fee.value
      self.update_column(:value_to_redeem, invested_amount * (fee_value / 100))
    end
end