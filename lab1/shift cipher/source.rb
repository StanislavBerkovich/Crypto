#shift cipher

ALPHABET = 'abcdefghijklmnopqrstuvwxyz '.freeze

def crypt input_text, key
	change_each_symbol input_text, key
end

def encrypt input_text, key
	change_each_symbol input_text, -key
end

def change_each_symbol text, count
	text.chars.inject('') { |res, ch|  res + ALPHABET[(ALPHABET.index(ch) + count) % ALPHABET.length] }
end		

input_text = File.open('in.txt'){ |file| file.read }.chop
key = File.open('key.txt'){ |file| file.read }.to_i
crypt_text = crypt(input_text, key) 
File.open('crypt.txt', 'w'){|file| file.write crypt_text }
File.open('encrypt.txt', 'w') {|file| file.write encrypt(crypt_text, key)}
