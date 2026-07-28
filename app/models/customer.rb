class Customer < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable
  validates_presence_of :first_name, :last_name, :contact_number
  validate :valid_contact_number_format

  def initials
    "#{first_name.first.upcase}#{last_name.first.upcase}"
  end

  def full_name
    "#{first_name.titleize} #{last_name.titleize}"
  end
end
