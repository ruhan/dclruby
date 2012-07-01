###############################################################################
# Classes handling the dymanic imports 
###############################################################################

=begin
    Class that surrounds a hash that takes all the modules used by the dclchk
=end
module ModuleCache
    @cache = {}

    def self.add_module(mod_name, constants_included)
        if not @cache[mod_name]
            @cache[mod_name] = []
        end

        # Add the constants added do this module 
        @cache[mod_name] += constants_included
    end

    def self.get_mod(mod, class_name)
        # Find an entry on cache
        if not @cache[mod]
            []
        else
            @cache[mod].find_all {|x| x.to_s() == class_name}
        end
    end

    def self.get_module(mod_name)
       @cache[mod_name] 
    end

    def self.cache
        @cache
    end
end



=begin
Given a path, returns all the global names associated with it.
This functions works just once for each global name associated,
because it made changes on the global scope.

Because that we have to retain on each call to this func the names
returned, so a second call won't produce results


TODO TESTAR OUTRA SOLUÇÃO VENDA DO IRC:
  mod = Module.new
  mod.module_eval(File.read('file.rb'))
  mod.constants


TENTAR TAMBÉM
https://github.com/rubyworks/loaded

=end
def globals_of_module(mod_name)
=begin    $M = Module.new do
        @included = mod_name

        def get_names_added
=end
    before = Array.new(Module.constants())

    begin
        require_relative mod_name
    rescue LoadError
        raise LoadError, "Modulo #{mod_name} nao esta no path"
    end

    after = Array.new(Module.constants())

    # gets the difference in the namespace between the moment before
    # and after the make of the include 
    diff = after - before

    # if something was found
    if diff != []
        ModuleCache.add_module(mod_name, diff)
    else
        # Nothing was found it means two things:
        # 1 - the module is really empty
        # 2 - the names within the module was included before, and we 
        # need to find them
        mod = ModuleCache.get_module(mod_name)
        if not mod 
            return nil
        else
            return mod
        end
    end
=begin            end
            
        end
    end

    include $M
    $M::get_names_added()
=end
end



# Only run the following code when this file is the main file being run
# instead of having been required or loaded by another file
if __FILE__ == $0
    # Find the parent directory of this file and add it to the front
    # of the list of locations to look in when using require
    $:.unshift File.join(File.dirname(__FILE__),'..')
    $:.unshift File.join(File.dirname(__FILE__),'.')

    a = 'system/view'
    b = 'system/model'

    require 'pp'

    puts 'XXXXXX'
    puts globals_of_module(a)

    puts 'YYYYYY'

    PP.pp(ModuleCache, $>, 40)


    puts globals_of_module(b)

    puts 'ZZZZZZ'

    PP.pp(ModuleCache, $>, 40)

    puts globals_of_module(a)

    puts 'AAAAAA'    
end

