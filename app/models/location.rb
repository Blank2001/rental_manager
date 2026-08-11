class Location < ApplicationRecord
  extend FriendlyId
  friendly_id :location_slug, use: :slugged
  belongs_to :company
  default_scope { order(is_default: :desc, hidden: :asc, allows_collection: :desc, allows_return: :desc)}
  
  attr_accessor :current_step, :city ,:country

  STEPS = %w[ coordinates info ].freeze

  validates :latitude, :longitude, presence: true, if: -> { required_for_step?(:coordinates) }
  validates :name, presence: true, if: -> { required_for_step?(:info) }

  def location_slug
    return "#{OpenSSL::Digest.hexdigest('sha1', self.id.to_s)}"
  end

  def required_for_step?(step)
    return false if self.current_step.nil?
    STEPS.index(step.to_s) <= STEPS.index(self.current_step.to_s)
  end
end
