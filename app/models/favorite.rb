class Favorite < ApplicationRecord
  belongs_to :user

  validates :character_id, presence: true
  validates :character_name, presence: true
  validates :character_image_url, presence: true

  validates :character_id, uniqueness: { scope: :user_id, message: "Ya está en tus favoritos" }
end
