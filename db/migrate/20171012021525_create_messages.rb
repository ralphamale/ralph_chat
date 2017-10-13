class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :author_id, null: false
      t.text :content
      t.integer :conversation_id, null: false

      t.timestamps null: false
    end

    add_index :messages, :conversation_id
    add_index :messages, :author_id
  end
end
