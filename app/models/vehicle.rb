class Vehicle < ApplicationRecord
  belongs_to :company
  attr_accessor :current_step

  STEPS = %w[basics specifications pricing ].freeze
  VEHICLE_CATEGORIES = [ "Convertible", "Coupe", "Hatchback", "Jeep", "Sedan", "Wagon", "Van" ]
  TRANSMISSION_TYPES = [ "Automatic", "Standard" ]
  FUEL_TYPE = [ "Electric", "Diesel", "Diesel-Hybrid", "Gas", "Gas-Hybrid" ]

  validates :category, :brand, :model, :year, presence: true, if: -> { required_for_step?(:basics) }
  validates :transmission_type, :fuel_type, :seats, :doors, presence: true, if: -> { required_for_step?(:specifications) }
  validates :daily_rate,presence: true, numericality: true, if: -> { required_for_step?(:pricing) }
  validates :security_deposit, presence: true, numericality: true, if: -> { required_for_step?(:pricing) && security_deposit_applicable? }

  def required_for_step?(step)
    return false if self.current_step.nil?
    STEPS.index(step.to_s) <= STEPS.index(self.current_step.to_s)
  end
end
