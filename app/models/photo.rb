class Photo < ApplicationRecord
  belongs_to :vehicle
  has_one_attached :image
  default_scope { order(:position) }

  def image_url
    return "#{Rails.application.routes.url_helpers.rails_blob_path(self.image, only_path: true)}"
  end
end
