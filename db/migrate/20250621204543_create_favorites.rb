class CreateFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :character_id
      t.string :character_name
      t.string :character_image_url

      t.timestamps
    end
  end
end
