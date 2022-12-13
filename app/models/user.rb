class User < ApplicationRecord
  has_many :party_users
  has_many :parties, through: :party_users

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_secure_password
  def parties_invited_to
    parties.where('party_users.host = ?', false)
  end

  def parties_hosting
    parties.where('party_users.host = ?', true)
  end

  def other_users
    User.where('id != ?', id)
  end
end
