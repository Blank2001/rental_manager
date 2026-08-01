class Reservation < ApplicationRecord
  extend FriendlyId
  friendly_id :reservation_slug, use: :slugged

  belongs_to :customer
  belongs_to :vehicle
  
  attr_accessor :current_step

  STEPS = %w[ dates, location ].freeze

  def id_slug
    return "#{OpenSSL::Digest.hexdigest('sha1', self.id.to_s)}"
  end

  def period
    return ((self.collection_date..self.return_date).count - 1)
  end

  def subtotal
    return (self.vehicle.daily_rate * self.period)
  end
end
