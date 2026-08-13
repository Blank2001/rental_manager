class Company < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  belongs_to :renter
  has_many :vehicles
  has_many :locations

  has_one_attached :logo
  has_one_attached :hero_image

  validates :name, :address, :country, :email, :phone_number, presence: true

  SUPPORTED_COUNTRIES = ['Antigua & Barbuda', 'Grenada', 'Montserrat', 'Saint Lucia' ]

  def hero_background_image
    if !self.hero_image.attached?
      return "url(https://images.unsplash.com/photo-1526726538690-5cbf956ae2fd?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)"
    else
      return "url(#{Rails.application.routes.url_helpers.rails_blob_path(self.hero_image, only_path: true)})"
    end
  end

  def collection_locations
    return self.locations.where(hidden: false, allows_collection: true)
  end

  def return_locations
    return self.locations.where(hidden: false, allows_return: true)
  end
end
