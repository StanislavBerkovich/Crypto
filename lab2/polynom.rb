require 'pry'

class Polynom
  attr_reader :coefficents

  def initialize(*arr)
    @coefficents = arr
    count_coefficents!
  end

  def zero?
    @coefficents.empty?
  end

  def one?
    @coefficents == [0]
  end

  def +(a)
    poly = self.clone
    case a
      when Fixnum
        poly.add_int(a)
      when Polynom
        poly.coefficents.push(*a.coefficents)
        poly.count_coefficents!
      else
        poly.invalid_type
    end
  end

  def *(a)
    invalid_type unless a.is_a? Polynom
    poly = self.clone
    res = Polynom.new
    a.coefficents.each do |a_c|
      res = res + poly.high_degree(a_c)
    end
    res
  end

  def inverse_by_module(m)
    poly = self.clone
    res = Polynom.new(1)
    pr_res = nil
    begin
      pr_res = res.clone
      res = (res * poly) % m
    end while !res.one?
    pr_res
  end

  def inspect
    coefficents.reverse.inject('') do |res, c|
      res + "+ x^#{c}"
    end
  end

  def / (a)
    devide(a)[0]
  end

  def % (a)
    devide(a)[1]
  end

  def ^ (n)
    poly = self.clone
    res = Polynom.new(0)
    while !n.zero?
      if n.odd?
        res *= poly
        n -= 1
      end
      poly *= poly
      n /= 2
    end
    res
  end


  protected

  def devide(a)
    poly = self.clone
    poly.recursive_devide(a, [Polynom.new, poly])
  end

  def recursive_devide(a, res)
    deg_diff = deg - a.deg
    return res if deg_diff < 0
    a_copy = a.high_degree(deg_diff)
    ost = a_copy + self
    dev = res[0] + Polynom.new(deg_diff)
    ost.recursive_devide(a, [dev, ost])
  end

  def high_degree(step)
    poly = self.clone
    poly.coefficents.map! { |c| c + step }
    poly
  end

  def deg
    zero? ? 0 : coefficents.max
  end

  def clone
    Polynom.new(*coefficents)
  end

  def invalid_type
    raise Error('invalid type')
  end


  def add_int(a)
    if a.even?
      self
    else
      @coefficents << 0
      count_coefficients!
    end
  end

  def has_coefficient(number)
    coefficents.bsearch { |c| c == number }
  end

  def count_coefficents!
    all_avalible = @coefficents.uniq
    all_avalible.each do |coef|
      count = @coefficents.count(coef)
      @coefficents.delete(coef)
      @coefficents << coef if count.odd?
    end
    @coefficents.sort!
    self
  end
end


a = Polynom.new(1,0)
b = Polynom.new(2,1,0)
p a.inverse_by_module(b)
p b % a
p b / a
p b ^ 1
p b ^ 2
p b ^ 3
p b ^ 4
