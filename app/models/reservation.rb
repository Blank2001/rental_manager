class Reservation < ApplicationRecord
  extend FriendlyId
  friendly_id :reservation_slug, use: :slugged

  belongs_to :customer
  belongs_to :vehicle
  
  attr_accessor :current_step

  STEPS = %w[ dates collection return  ].freeze
  RESERVATION_TYPES = ["maintenance", "offline", "online"]

  validates :collection_date, :return_date, presence: true, numericality: true, if: -> { required_for_step?(:dates) }
  validate :valid_dates?
  validate :valid_rental_period?
  validate :vehicle_available?

  def reservation_slug
    return "#{OpenSSL::Digest.hexdigest('sha1', self.id.to_s)}"
  end

  def period
    return ((self.collection_date..self.return_date).count > 1 ? ((self.collection_date..self.return_date).count - 1) : 1)
  end

  def subtotal
    return (self.vehicle.daily_rate * self.period)
  end

  def valid_dates? 
    if self.collection_date < Date.today && self.res_type == "online"
      errors.add(:base, "You cannot book a rental in the past")
      return false
    elsif self.return_date < self.collection_date
      errors.add(:base, "Collection date must be before return date")
      return false
    else
      return true
    end
  end

  def valid_rental_period? 
    if self.period < self.vehicle.minimum_days && self.res_type == "online"
      errors.add(:base, "You are required to book this vehicle for atleast #{self.vehicle.minimum_days} days")
      return false
    else
      return true
    end
  end

  def vehicle_available?
    if self.vehicle.reservations.where(vehicle_id: self.vehicle_id, collection_date: collection_date..return_date, return_date: collection_date..return_date).none?
      return true
    else
      errors.add(:base, "The vehicle is currently not available")
      return false
    end
  end

  def required_for_step?(step)
    return false if self.current_step.nil?
    STEPS.index(step.to_s) <= STEPS.index(self.current_step.to_s)
  end
end
