module Synthea
  class Hospital < Synthea::Provider
    cattr_accessor :hospital_list # Array - all hospitals that are imported

    def initialize(properties, coordinates)
      super(properties, coordinates)
      Hospital.hospital_list.push(self)
    end

    # rubocop:disable Style/ClassVars
    # from module.rb
    def self.hospital_list
      @@hospital_list ||= []
    end

    # find closest hospital with ambulatory service
    def self.find_closest_ambulatory(person_location)
      person_point = GeoRuby::SimpleFeatures::Point.from_x_y(person_location[0], person_location[1])
      closest_distance = 100_000_000
      closest_hospital = nil
      @@services[:ambulatory].each do |h|
        hospital_location = h.attributes[:coordinates]
        hospital_point = GeoRuby::SimpleFeatures::Point.from_x_y(hospital_location[0], hospital_location[1])
        spherical_distance = hospital_point.spherical_distance(person_point)
        if spherical_distance < closest_distance
          closest_distance = spherical_distance
          closest_hospital = h
        end
      end
      closest_hospital
    end

    # find closest hospital with inpatient service
    def self.find_closest_inpatient(person_location)
      person_point = GeoRuby::SimpleFeatures::Point.from_x_y(person_location[0], person_location[1])
      closest_distance = 100_000_000
      closest_hospital = nil
      @@services[:inpatient].each do |h|
        hospital_location = h.attributes[:coordinates]
        hospital_point = GeoRuby::SimpleFeatures::Point.from_x_y(hospital_location[0], hospital_location[1])
        spherical_distance = hospital_point.spherical_distance(person_point)
        if spherical_distance < closest_distance
          closest_distance = spherical_distance
          closest_hospital = h
        end
      end
      closest_hospital
    end

    # find closest hopital with emergency service
    def self.find_closest_emergency(person_location)
      person_point = GeoRuby::SimpleFeatures::Point.from_x_y(person_location[0], person_location[1])
      closest_distance = 100_000_000
      closest_hospital = nil
      @@services[:emergency].each do |h|
        hospital_location = h.attributes[:coordinates]
        hospital_point = GeoRuby::SimpleFeatures::Point.from_x_y(hospital_location[0], hospital_location[1])
        spherical_distance = hospital_point.spherical_distance(person_point)
        if spherical_distance < closest_distance
          closest_distance = spherical_distance
          closest_hospital = h
        end
      end
      closest_hospital
    end

    def self.clear
      super
      Hospital.hospital_list.clear
    end
  end
end
