class Admin < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable
  has_one_attached :signature
  
  def initials
    "#{first_name.first.upcase}#{last_name.first.upcase}"
  end

  def full_name
    "#{first_name.titleize} #{last_name.titleize}"
  end
end
