class Product < ApplicationRecord
    belongs_to :fee
    
    validates :name, presence: true, uniqueness: true, length: { minimum: 4, maximum: 100 }
    validates :start_date, :end_of_term, presence: true
    validates :minimum_investment_amount, presence: true
    validates :index, presence: true
  end