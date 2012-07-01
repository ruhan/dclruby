require "proxy_machine"
require "binding_of_caller"

require_relative "proxy"

require_relative "statemachine"

#require_relative "modulecache"

###############################################################################
# TYPES OF FACTS:
#  * :methodcall
#  * :inheritance
#  * :objcreation
###############################################################################



###############################################################################
# Marks in the code, informations catched from the code that will be used in 
# the arquitecture analysis
###############################################################################
# Fact is an action that occurs in the program
module FactLogger
    @facts = []

    def self.facts
      return @facts
    end

    def self.method_call(sender, obj, method_name, args)
        #puts DCL.mods

        fact = {type: :methodcall, sender: sender, 
                object: obj, method: method_name, args: args}

        @facts.push(fact)
        DCL.notify_fact(fact)
    end

    def self.class_inheritance(parent, subclass)        
        #puts DCL.mods

        fact = {type: :inheritance, parent: parent, cls: subclass}
        @facts.push(fact)

        DCL.notify_fact(fact)
    end

    def self.object_create(sender, cls, args)
        #puts DCL.mods

        fact = {type: :objcreation, cls: cls, args: args, sender: sender}

        @facts.push(fact)
        DCL.notify_fact(fact)
    end
end





###############################################################################
# Activates the Fact class on the following events: creating an objects, 
# inheriting from a class of calling an object' method
###############################################################################

def func &block
  proxy_machine_config = ProxyMachine::Config.new
  proxy_machine_config.apply!(&block)
  proxy_machine_config
end  

class Class
  def inherited(subclass)
      FactLogger.class_inheritance(self, subclass)     


      class << subclass
          def new(*args)
              # Creating that function only to use a block as a parameter
              proxy_machine_config = func do
                  before_all {|obj, method, args| 
                      sender = binding.of_caller(4).eval('self')
                      # Removing the problem with deep stack calling
                      if not sender.to_s == "DCL"
                        FactLogger.method_call(sender, obj, method, args)
                      end
                  }   
              end 

              obj = allocate
              obj.send(:initialize, *args)

              # Mark an created object
              FactLogger.object_create(
                  binding.of_caller(2).eval('self'), 
                  obj, 
                  args
              )

              # Returning a object proxy in place of the real object
              proxy_for obj, proxy_machine_config.callbacks
          end 
      end 

  end
end




if __FILE__ == $0
    $:.unshift File.join(File.dirname(__FILE__),'..')
    $:.unshift File.join(File.dirname(__FILE__),'.')

    a = Hash.new
    puts FactLogger.facts

	class Hello
	  def say_it
	    Chupa.new.maria("yes")
	    return "Hello!"
	  end
	end

	class Chupa
	  def maria(chu)
	  end
	end


	Hello.new.say_it
	Chupa.new.maria("caramba")
	puts "--"
	puts FactLogger.facts
end
