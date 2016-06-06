# 1. Ben.  He is called the getter method for balance made possible by attr_reader

# 2. There is no setter method for quantity because the code uses attr_reader instead
# of attr_accessor.  Therefore the code will result in a no method error for quantity=.
# You could add an @ before quatity to set the instance variable or change attr_reader to 
# attr_accessor and use the setter method self.quantity = 

# 3. By changing to attr_accessor you would need to call the setter method using self.quantity.
# Also, the quantity can now be changed directly without calling the update_quantity method.

# 4. 

class Greeting
  def greet(string)
    puts string
  end
end

class Hello < Greeting
  def hi
    greet "hello"
  end
end

class Goodbye < Greeting
  def goodbye
    greet "Goodbye"
  end
end

hello = Greeting.new

hello.greet("Whats up?")

hi = Hello.new
bye = Goodbye.new

hi.hi

bye.goodbye

# 5. 

class KrispyKreme
  attr_reader :filling_type, :glazing

  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    donut_description = filling_type ? filling_type : 'Plain'
    donut_description += " with #{glazing}" if glazing
    donut_description
  end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1
puts donut2
puts donut3
puts donut4
puts donut5

# 6. The methods in both examples are not needed because getter and setter methods have 
# already been created via attr_accessor.

# 7. Change it from light_information to just information





