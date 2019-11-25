class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string :topic
      t.string :verse
      t.text :body
      t.integer :user_id
    end
  end
end
