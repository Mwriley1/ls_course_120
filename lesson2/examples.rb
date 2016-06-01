class Animal
  def run
    'running!'
  end

  def jump
    'jumping'
  end
end

class Dog < Animal
  def speak
    'bark'
  end

  def swim
    'swimming'
  end

  def fetch
    'fetching'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

class Cat < Animal
  def speak
    'meowing'
  end
end


teddy = Dog.new
blue = Bulldog.new
whiskers = Cat.new

puts teddy.speak
puts teddy.swim
puts teddy.run
puts teddy.fetch
puts teddy.jump

puts blue.speak
puts blue.swim
puts blue.run
puts blue.fetch
puts blue.jump

puts whiskers.run
puts whiskers.jump
puts whiskers.speak

class Person
   attr_accessor :first_name, :last_name
   
   def initialize(name)
       parse_full_name(name)
   end
   
   def name
       self.first_name + " #{self.last_name}"
   end
   
   def name=(name)
       parse_full_name(name)
   end
   
   private
   
   def parse_full_name(name)
       self.first_name = name.split.first
       self.last_name = name.split.length > 1 ? name.split.last : ''
   end
   
   def to_s
       name
   end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

p bob.name == rob.name
puts "The person's name is #{bob}"

class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    self.name   = n
    self.height = h
    self.weight = w
  end

  def change_info(n, h, w)
    self.name   = n
    self.height = h
    self.weight = w
  end

  def info
    "#{self.name} weighs #{self.weight} and is #{self.height} tall."
  end
  
  def what_is_self
    self
  end
end

sparky = GoodDog.new('Sparky', '12 inches', '10 lbs')

p sparky.what_is_self




