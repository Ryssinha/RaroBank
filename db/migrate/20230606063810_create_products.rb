class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, length: { minimum: 2, maximum: 100 }
      t.integer :punctuation
      t.date :start_date, null: false
      t.date :end_of_term, null: false
      t.decimal :minimum_investment_amount, null: false
      t.string :index, null: false

      t.timestamps
    end
  end
end
