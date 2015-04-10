require 'pry'
class Polynom
  attr_reader :number

  def initialize(arg)
    @number = arg.is_a?(Array) ? arg.join('').to_i(2) : arg  
  end

  def +(a)
  	invalid_type unless a.is_a? Polynom
 
    Polynom.new(number ^ a.number)
  end

  def *(a)
    invalid_type unless a.is_a? Polynom
 
    a_number = a.number 
    bits_count = 0
    res = 0
    while a_number != 0 do
    	curr_bit = a_number & 1
    	a_number = a_number >> 1
    	unless curr_bit.zero?
    		res ^= (number << bits_count)	
    	end
    	bits_count += 1
    end
    Polynom.new(res)
  end

  def inverse_by_module(m)
    res = Polynom.new(1)
    pr_res = nil
    begin
      pr_res = res.clone
      res = (res * self) % m
    end while res.number != 1
    pr_res
  end

  def inspect
  	number.to_s(2)
  end

  def / (a)
    devide(a)[0]
  end

  def % (a)
    devide(a)[1]
  end

  def ** (n)
    poly = self.clone
    res = Polynom.new(1)
    while !n.zero?
      if n.odd?
        res *= poly
      end
      poly *= poly
      n = n >> 1
    end
    res
  end

  protected

  def devide(a)
    poly = self.clone
    poly.recursive_devide(a, [Polynom.new(0), poly])
  end

  def recursive_devide(a, res)
    deg_diff = deg - a.deg
    return res if deg_diff < 0
    a_copy = a.high_degree(deg_diff)
    ost = a_copy + self
    dev = res[0] + Polynom.new(1 << deg_diff)
    ost.recursive_devide(a, [dev, ost])
  end

  def high_degree(step)
    Polynom.new(number << step)
  end

  def deg
  	n = number
    count = 0
    while n != 0 do
    	n = n >> 1
    	count += 1
    end
    count
  end

  def clone
    Polynom.new(number)
  end

  def invalid_type
    raise Error('invalid type')
  end
end


operation, b = nil, nil

m = Polynom.new(File.open('poly.txt'){ |file| file.read }.split(' '))
lines = File.open('input.txt'){ |file| file.read }.lines.map(&:strip)
a = Polynom.new(lines[0].split(' '))


if lines.length == 3
	operation = lines[1]
else
	if (operation = lines[2].strip) == '**'
		b = lines[1].to_i
	else	
		b = Polynom.new(lines[1].split(' '))
	end
end	

res = if b
			a.send(operation, b).send(:%, m)
	else
		if operation == 'inverse'
			a.inverse_by_module(m)
		else
			a.public_send(operation).public_send(:%, m)
		end	
	end 

p res
