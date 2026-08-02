class Vehicle < ApplicationRecord
  extend FriendlyId
  friendly_id :name_slug, use: :slugged
  belongs_to :company
  has_many :photos, -> { order(:position) }, dependent: :destroy
  has_many :reservations
  attr_accessor :current_step

  STEPS = %w[basics specifications pricing ].freeze
  VEHICLE_CATEGORIES = [ "Convertible", "Coupe", "Hatchback", "Jeep", "Sedan", "Wagon", "Van" ]
  TRANSMISSION_TYPES = [ "Automatic", "Standard" ]
  FUEL_TYPE = [ "Electric", "Diesel", "Diesel-Hybrid", "Gas", "Gas-Hybrid" ]

  validates :category, :brand, :model, :year, presence: true, if: -> { required_for_step?(:basics) }
  validates :transmission_type, :fuel_type, :seats, :doors, presence: true, if: -> { required_for_step?(:specifications) }
  validates :minimum_days, :daily_rate, presence: true, numericality: true, if: -> { required_for_step?(:pricing) }
  validates :security_deposit, presence: true, numericality: true, if: -> { required_for_step?(:pricing) && security_deposit_applicable? }

  def name_slug
    return "#{self.company.name}-#{self.year}-#{self.brand}-#{self.model}"
  end

  def required_for_step?(step)
    return false if self.current_step.nil?
    STEPS.index(step.to_s) <= STEPS.index(self.current_step.to_s)
  end

  def self.available(collection_date, return_date)
    self.where(id: all.select { |vehicle|
      vehicle.reservations.where('collection_date < ? AND return_date > ?', collection_date, return_date ).none?
    }.map(&:id))
  end

  def self.available_today
    today = Date.current
    self.where(id: all.select { |vehicle|
      target_return_date = today + vehicle.minimum_days.days
      vehicle.reservations.where('collection_date < ? AND return_date > ?', target_return_date, today ).none?
    }.map(&:id))
  end
end
