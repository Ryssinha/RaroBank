class CreateJoinTableClassUser < ActiveRecord::Migration[7.0]
  def change
    create_join_table :classrooms, :users do |t|
      # t.index [:classroom_id, :user_id]
      # t.index [:user_id, :classroom_id]
    end
  end
end
