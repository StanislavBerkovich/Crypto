#simple substitution cipher
require 'yaml'
 
def substitution_with_key text, key
	text.chars.inject('') { |res, ch| res + key[ch] }
end


input_text = File.open('in.txt'){ |file| file.read }.chop
crypt_key = YAML::load_file('key.txt')

crypt_text = substitution_with_key(input_text, crypt_key) 
File.open('crypt.txt', 'w'){|file| file.write crypt_text }

encrypt_key = crypt_key.invert
File.open('encrypt.txt', 'w') {|file| file.write substitution_with_key(crypt_text, encrypt_key)}

