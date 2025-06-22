class User < ApplicationRecord
  has_secure_password

  has_many :favorites, dependent: :destroy

  EMAIL_FORMAT = /\A
    [a-zA-Z0-9._%+-]+            # nombre de usuario
    @                            # símbolo @
    [a-zA-Z0-9.-]+              # dominio
    \.                          # punto
    [a-zA-Z]{2,}                # extensión del dominio (.com, .cl, etc)
  \z/x

  PASSWORD_FORMAT = /\A
    (?=.*\d)           # Debe contener al menos un número
    (?=.*[a-z])        # Debe contener al menos una minúscula
    (?=.*[A-Z])        # Debe contener al menos una mayúscula
    [a-zA-Z\d]{8,}     # Debe tener al menos 8 caracteres
  /x

  before_save :sanitize_inputs, :downcase_email

  validates :name, presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 30 },
            format: {
              with: /\A[a-zA-Z0-9_\s]+\z/,
              message: "solo puede contener letras, números, espacios y guiones bajos"
            }

  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: EMAIL_FORMAT,
                    message: "debe tener un formato válido (tu@email.com)" },
            length: { maximum: 255 }

  validates :password,
            presence: true,
            length: { minimum: 8, message: "debe tener al menos 8 caracteres" },
            format: { with: PASSWORD_FORMAT,
                    message: "debe contener al menos una mayúscula, una minúscula y un número" },
            if: :password_required?

  private

  def password_required?
    new_record? || password.present?
  end

  def sanitize_inputs
    self.name = sanitize_string(name)
    self.email = sanitize_string(email)
  end

  def sanitize_string(str)
    return str unless str.is_a?(String)
    ActionController::Base.helpers.sanitize(str, tags: [], attributes: [])
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
