class Investment < ApplicationRecord
    belongs_to :user
    belongs_to :product
  
    validates :user, presence: true
    validates :product, presence: true

    before_save :calculate_value_to_redeem

    private
  
    def calculate_value_to_redeem
      self.value_to_redeem = invested_amount * 1.1
    end
end