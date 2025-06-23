require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validaciones' do
    subject { build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(30) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:email).is_at_most(255) }

    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8)
          .with_message('La contraseña debe tener al menos 8 caracteres') }
  end

  describe 'validación de email' do
    it 'acepta formatos válidos de email' do
      valid_emails = [ 'user@example.com', 'USER@foo.COM', 'A_US-ER@foo.bar.org' ]

      valid_emails.each do |email|
        user = build(:user, email: email)
        expect(user).to be_valid
      end
    end

    it 'rechaza formatos inválidos de email' do
      invalid_emails = [ 'user@example,com', 'user_at_foo.org', 'user.name@example.' ]

      invalid_emails.each do |email|
        user = build(:user, email: email)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('El formato del email debe ser tu@email.com')
      end
    end
  end

  describe 'validación de contraseña' do
    it 'requiere mayúscula, minúscula y número' do
      user = build(:user, password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('La contraseña debe contener al menos una mayúscula, una minúscula y un número')

      user.password = 'Password1'
      expect(user).to be_valid
    end
  end

  describe 'validación de nombre' do
    it 'acepta formatos válidos de nombre' do
      valid_names = [ 'John Doe', 'john_doe', 'JohnDoe123' ]

      valid_names.each do |name|
        user = build(:user, name: name)
        expect(user).to be_valid
      end
    end

    it 'rechaza formatos inválidos de nombre' do
      invalid_names = [ 'John@Doe', 'john$doe', 'John#123' ]

      invalid_names.each do |name|
        user = build(:user, name: name)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include('El nombre solo puede contener letras, números, espacios y guiones bajos')
      end
    end
  end
end
