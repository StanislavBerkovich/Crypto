
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
    "Простое"
end


def miller_rabin_primality_test(n, k = 100)
    return "Составное" if n & 1 == 0
        
    t = n - 1
    s = 0
    while t & 1 == 0 do
        s += 1
        t >>= 1
    end
    k.times do
        a = rand(2..n - 2)
        x = modulo_pow(a, t, n)
        next if x == 1 or x == n - 1
        (s - 1).times do
            x = modulo_pow(x, 2, n)
            return "Cоставное" if x == 1
            break  if x == n - 1
        end     
        return "Составное" if x != n - 1
    end     
    "Простое"
end

def randbits(l)
    res = '1'
    (l-1).times do
        res += rand(0..1).to_s
    end
    res.to_i(2)
end

def simple_test(n)
    s = Math.sqrt(n).to_i
    a = (2..s).find do |i|
        n % i == 0
    end
    if a.nil?
        "Простое"
    else
        "Составное"
    end
end 

def generate_pseudo_primary_number(n, k)
    loop do
        a = randbits(n)
        a |= 1
        a |= 1 << n - 1
        l = [
            3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107,
            109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227,
            229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349,
            353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467,
            479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613,
            617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751,
            757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887,
            907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997, 1009, 1013, 1019, 1021, 1031, 1033,
            1039, 1049, 1051, 1061, 1063, 1069, 1087, 1091, 1093, 1097, 1103, 1109, 1117, 1123, 1129, 1151, 1153, 1163,
            1171, 1181, 1187, 1193, 1201, 1213, 1217, 1223, 1229, 1231, 1237, 1249, 1259, 1277, 1279, 1283, 1289, 1291,
            1297, 1301, 1303, 1307, 1319, 1321, 1327, 1361, 1367, 1373, 1381, 1399, 1409, 1423, 1427, 1429, 1433, 1439,
            1447, 1451, 1453, 1459, 1471, 1481, 1483, 1487, 1489, 1493, 1499, 1511, 1523, 1531, 1543, 1549, 1553, 1559,
            1567, 1571, 1579, 1583, 1597, 1601, 1607, 1609, 1613, 1619, 1621, 1627, 1637, 1657, 1663, 1667, 1669, 1693,
            1697, 1699, 1709, 1721, 1723, 1733, 1741, 1747, 1753, 1759, 1777, 1783, 1787, 1789, 1801, 1811, 1823, 1831,
            1847, 1861, 1867, 1871, 1873, 1877, 1879, 1889, 1901, 1907, 1913, 1931, 1933, 1949, 1951, 1973, 1979, 1987,
            1993, 1997, 1999]

        if a < l.max 
            return a if l.include?(a)
            next
        end


        flag = 0
        l.each do |i|
            if a % i == 0
                flag = 1
                break
            end
        end
        
        next if flag == 1

        if miller_rabin_primality_test(a, k)
            # print(a)
            return a
        end
    end
end


def generate_primary_number(n)
    s = generate_pseudo_primary_number(n / 4, n / 3)
    t = generate_pseudo_primary_number(n / 4, n / 3)
    i = rand(2..n - 1)
    while miller_rabin_primality_test(2 * i * t + 1, n) == "Cоставное" do
        i += 1
    end
    r = 2 * i * t + 1
    p_0 = 2 * modulo_pow(s, r - 2, r) * s - 1
    j = rand(2..n - 1)
    while miller_rabin_primality_test(p_0 + 2 * j * r * s, n) == "Составное" do
        j += 1
    end
    p = p_0 + 2 * j * r * s
    return p
end



a = generate_primary_number(120)
puts a
puts a.to_s(2)

puts a.to_s(2).size

puts miller_rabin_primality_test(a)
puts simple_test(a)
puts s_s_test(a)
