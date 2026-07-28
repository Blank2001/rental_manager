class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  private
    def valid_contact_number_format
      unless contact_number.length >= 10 && contact_number.match?(/\A\d{1,4}\d{6,14}\z/)
        errors.add(:contact_number, "must be a valid international phone number")
      end
    end
end
