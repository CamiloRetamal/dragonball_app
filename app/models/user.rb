class User < ApplicationRecord
  has_secure_password

  has_many :favorites, dependent: :destroy

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Debe ser un email válido" }
  validates :name, presence: true, uniqueness: true,
            length: { minimum: 3, maximum: 30 },
            format: { with: /\A[a-zA-Z0-9_\s]+\z/, message: "Solo puede contener letras, números, espacios y guiones bajos" }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  private

  def password_required?
    new_record? || password.present?
  end
end
