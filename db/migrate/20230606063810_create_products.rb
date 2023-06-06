class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.date :start_date
      t.date :end_of_term
      t.decimal :minimum_investment_amount
      t.string :index

      t.timestamps
    end
    add_index :products, :minimum_investment_amount
  end
end
