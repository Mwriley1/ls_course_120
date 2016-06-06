# 1. 

# class SecretFile
#   def initialize(secret_data, security_logger)
#     @data = secret_data
#     @security_logger = security_logger
#   end

#   def data
#     @security_logger.create_log_entry
#     @data
#   end

#   def display_security_log
#     @security_logger.log
#   end
# end

# class SecurityLogger
#   attr_reader :log

#   def initialize
#     @log = []
#   end

#   def create_log_entry
#     log << "Data accessed at #{Time.new}"
#   end
# end

# file = SecretFile.new("Michael Riley", SecurityLogger.new)

# p file.data
# p file.data

# p file.display_security_log

# p file.data
# p file.data

# p file.display_security_log


# 2. 

module Moveable
  attr_accessor :speed, :heading
  attr_writer :fuel_capacity, :fuel_efficiency

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include Moveable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures along with
    super([20,20], 80, 8.0)
  end
end

class MotorBoat
  include Moveable

  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    self.fuel_capacity = liters_of_fuel_capacity
    self.fuel_efficiency = km_traveled_per_liter
  end

  def range
    super + 10
  end
end

class Catamaran < MotorBoat
  attr_accessor :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    super(km_traveled_per_liter, liters_of_fuel_capacity)
  end
end

car = Auto.new
motorcycle = Motorcycle.new
catamaran = Catamaran.new(2, 3, 30, 120)
boat = MotorBoat.new(50,100)

p car.range
p motorcycle.range
p catamaran.range
p boat.range






