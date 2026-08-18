class Reservation < ApplicationRecord
  extend FriendlyId
  friendly_id :reservation_slug, use: :slugged

  belongs_to :customer, optional: true
  belongs_to :vehicle
  
  attr_accessor :current_step

  STEPS = %w[ dates collection return summary ].freeze
  RESERVATION_TYPES = ["maintenance", "offline", "online"]
  ADMIN_RESERVATION_TYPES = ["maintenance", "offline"]

  validates :collection_location, presence: { message: "A location must be selected before continuing" }, if: -> { required_for_step?(:collection) && self.res_type != "maintenance" }
  validates :return_location, presence: { message: "A location must be selected before continuing" }, if: -> { required_for_step?(:return) && self.res_type != "maintenance" }
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

  def total
    total = self.subtotal
    if !self.collection_location.nil? && Location.find(self.collection_location).additional_cost > 0
      total += Location.find(self.collection_location).additional_cost.to_f
    end
    if !self.return_location.nil? && Location.find(self.return_location).additional_cost > 0
      total += Location.find(self.return_location).additional_cost.to_f
    end
    return total
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
    if self.vehicle.reservations.where.not(id: self.id).where(vehicle_id: self.vehicle_id, collection_date: collection_date..return_date, return_date: collection_date..return_date).none?
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

  def status_colour
    case self.status
    when 'completed'
      return 'primary'
    when 'on-hire'
      return 'info'
    when 'reserved'
      return 'green'
    when 'declined'
      return 'red'
    when 'pending'
      return 'yellow'
    when nil
      return 'muted'
    end
  end
end
