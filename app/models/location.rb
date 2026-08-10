class Location < ApplicationRecord
  extend FriendlyId
  friendly_id :location_slug, use: :slugged
  belongs_to :company
  
  attr_accessor :current_step, :city ,:country

  STEPS = %w[ coordinates, info ].freeze

  def location_slug
    return "#{OpenSSL::Digest.hexdigest('sha1', self.id.to_s)}"
  end
end
