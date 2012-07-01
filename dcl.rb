# ModuleDef
require_relative "moduledef"

# Logging
require_relative "factlogging"

# The base classes
require_relative "statemachine"

# System constraints
require_relative "rules"


# Debug
require_relative "modulecache"





# Re-opening the class to define the DSL syntax

module DCL
    # Defining a module for DCL
    def mod(name, *paths)
        # example - mod :ModuleA, ['system/views']
        moddef = ModuleDef.new(name, paths)

        DCL.insert_mod(moddef)

        puts ModuleCache.cache

        moddef
    end


    # Constraint simple
    def the(mod_name, type_interaction, mod_target)
        mod = DCL.get_mod(mod_name)
        mod_target = DCL.get_mod(mod_target)

        rule = TheRule.new(mod, type_interaction, mod_target)
        DCL.insert_rule(rule)
    end   


    def only(mod_name, type_interaction, mod_target)
    end
end


if __FILE__ == $0
    $:.unshift File.join(File.dirname(__FILE__),'..')
    $:.unshift File.join(File.dirname(__FILE__),'.')

    class Architecture
        include DCL

        def run
            mod :model, 'system/model'
            mod :view, 'system/view'
            mod :controller, 'system/controller'
            mod :util, 'system/util'

            the :controller, :cant_access, :model
            the :view, :cant_access, :controller
            the :model, :cant_access, :view
            the :model, :cant_access, :controller

            # calls the system 
            require_relative 'system/main'
        end
    end

    Architecture.new.run
end



