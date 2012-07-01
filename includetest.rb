
$:.push('/home/juliocesar/Dropbox/archsw/dclruby/dclruby')


def import(mod)
	require mod
end


a = 'system/view'
b = 'system/model'


import(a)
import(b)


# nome do programa
#puts $0 

# nome do arquivo sendo executado agora
#puts __FILE__ 



puts self.methods
puts
puts

puts self.local_variables	


puts
puts
puts a.class
puts BlackSabbath.class
puts Cinderela.class

