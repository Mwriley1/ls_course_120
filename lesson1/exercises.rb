class Student
  attr_reader :name
  
  def initialize(name, grade)
    @name = name
    @grade = grade
  end
  
  def better_grade_than?(person)
    puts "Well done!" if self.grade < person.grade
  end
  
  protected
  
  attr_reader :grade
end

joe = Student.new("Joe", "A")
bob = Student.new("Bob", "B")

p joe.better_grade_than?(bob)

# the method 'hi' in Bob is private and not accessible outside the class
# To fix this you could move the hi method above the private keyword in the 
# class definition 


module Towable
  def can_tow?
    true    
  end
end

class Vehicle
  @@number_of_vehicles = 0
  
  attr_accessor :color, :year, :model, :current_speed
  
  def initialize(year, color, model)
    @@number_of_vehicles += 1
    @year = year
    @color = color
    @model = model
    @current_speed = 0
  end
  
  def self.number_of_vehicles
    puts "#{@@number_of_vehicles} vehicles have been created."
  end
  
  def self.gas_mileage(gallons, miles)
    puts "Your gas mileage is #{miles / gallons} miles per gallon."
  end
  
  def speed_up(speed)
    @current_speed += speed
    puts "Speeding up #{speed} MPH!"
  end
  
  def brake(speed)
    @current_speed -= speed
    puts "Braking by #{speed} MPH!"
  end
  
  def display_current_speed
    puts "You are going #{@current_speed} MPH."
  end
  
  def shut_off
    @current_speed = 0
    puts "Stopping and shutting off!"
  end
  
  def spray_paint(color)
    self.color = color
    puts "Spray painting #{color}!"
  end
  
  def to_s
    puts "This is a #{self.color} #{self.year} #{self.model} traveling at a speed of #{self.current_speed} miles per hour."
  end
  
  def age
    puts "The vehicle is #{years_old} years old!"
  end
  
  private
  
  def years_old
    Time.now.year - self.year
  end
end

class MyCar < Vehicle
  NUMBER_OF_WHEELS = 4
end

class MyTruck < Vehicle
  include Towable
  
  HAS_BED = true
end

car = MyCar.new(2013, 'Blue', 'Dodge Durango')
truck = MyTruck.new(2014, 'White', 'Toyota Tundra')

Vehicle.number_of_vehicles

p MyCar.ancestors
p MyTruck.ancestors
p Vehicle.ancestors

car.speed_up(80)
car.current_speed
car.brake(50)
car.current_speed
car.shut_off
car.current_speed

truck.speed_up(80)
truck.current_speed
truck.brake(50)
truck.current_speed
truck.shut_off
truck.current_speed

puts car.color
car.color = "Green"
puts car.color
puts car.year

car.spray_paint("Yellow")
puts car.color

MyCar.gas_mileage(50, 500)

car.age

# An error occurs because attr_reader only creates a getter method
# for :name not a setter method.  When you try to use a name= method
# to set bob's name it doesn't exist.  It can be fixed by changing
# attr_reader to attr_accessor, which will create both a getter and
# setter method for :name.

class Person
  attr_accessor :name
  def initialize(name)
    self.name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"

p bob.name