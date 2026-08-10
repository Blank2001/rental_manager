class Renter < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable
  validates_presence_of :first_name, :last_name, :contact_number
  validate :valid_contact_number_format
  has_many :companies

  def initials
    "#{first_name.first.upcase}#{last_name.first.upcase}"
  end

  def full_name
    "#{first_name.titleize} #{last_name.titleize}"
  end
  
  def maintenance_reservations
    return Reservation.where(vehicle_id: self.vehicles.ids, collection_date: ..Date.today, return_date: Date.today.., res_type: ["maintenance"])
  end
  
  def on_hire_reservations
    return Reservation.where(vehicle_id: self.vehicles.ids, collection_date: ..Date.today, return_date: Date.today.., res_type: ["offline", "online"])
  end

  def upcoming_reservations
    return Reservation.where(vehicle_id: self.vehicles.ids, collection_date: Date.today.., res_type: ["offline", "online"])
  end

  def reservations
    return Reservation.where(vehicle_id: self.vehicles.ids, res_type: ["offline", "online"])
  end

  def vehicles
    return Vehicle.where(company_id: Company.where(renter_id: self.id).ids)
  end
end
