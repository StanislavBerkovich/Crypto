
def j(a, n)
    r = 1

    if a < 0
        a = -a
        r = -r if n % 4 == 3
    end

    while a != 0 do
        t = 0
        while a & 1 == 0 do 
            t+= 1; a /= 2
        end          
        
        r = -r if (t & 1 == 1) && ((n % 8 == 3) || (n % 8 == 5))
        r = -r if a % 4 == 3 && n % 4 == 3

        c = a
        a = n % c
        n = c
    end       
    r
end

def modulo_pow(a, t, m)
    res = 1
    t.times do
       res = (res * a) % m 
    end
    res
end     

def s_s_test(n, k=100)
    k.times do
        a = rand(2..n-1)
        return "Составное" if a.gcd(n) > 1
        t = (n - 1) >> 1
        jl = modulo_pow(a, t, n)
        jl -= n if jl > 1
        return "Составное" if jl != j(a, n)
    end        
    return "Простое с верооятностью #{1 - 2 **(-k)}"
end

puts s_s_test(100, 2)
puts s_s_test(101)
puts s_s_test(10000001)