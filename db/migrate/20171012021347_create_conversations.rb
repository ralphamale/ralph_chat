class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :user1_id, null: false
      t.integer :user2_id, null: false

      t.timestamps null: false
    end

    add_index :conversations, [:user1_id, :user2_id], unique: true
  end
end
