class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, unique: true, length: { minimum: 4, maximum: 100 }
      t.integer :punctuation
      t.date :start_date, null: false
      t.date :end_of_term, null: false
      t.decimal :minimum_investment_amount, null: false
      t.references :fee, foreign_key: true
      t.string :image_url, null: false

      t.timestamps
    end
  end
end
