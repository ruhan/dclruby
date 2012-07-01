#http://slideshow.rubyforge.org/ruby19.html#27
#require 'ruby-debug'; debugger;
#puts $:



=begin
mod = ProxyMachine

mod
.constants
.collect{|c| mod.const_get(c)}
.each{|c| 
    puts c.to_s; c.instance_methods(false).each{|m| 
        puts ' ' + c.instance_method(m).to_s
    }
} 

puts mod.methods
=end










###############################################################################
# DSL
###############################################################################
# A rule defined by the user. Or, simply, an arquitecture constraint 
class Rule
end
=begin

class ModuleRule < Rule 
    attr_acessor :name, :modules
    @name = "" 
    @modules = []

    def initialize(name, modules)
        @name = name
        if modules.type != Array
            modules = [modules]
        end
        @modules = modules
    end
end

class TheRule < Rule
end

class OnlyRule < Rule

end


class ModuleList < List
    def get_mod(name)
        reject { |b| !match(b.name, 0, name) }
    end
end

# Methods used by the DCL language
class DCL
    attr_acessor :mods
    @mods = ModuleList([])

    @can_create = :can_create
    @can_access = :can_access
    @can_extend = :can_extend

    @cannot_create = :cannot_create
    @cannot_access = :cannot_access
    @cannot_extend = :cannot_extend

    # Create a module
    def mod(mod_name, *mods_path)
        @mods.push ModuleRule.new(mod_name, *mods_path)
    end

    def only(mods_name, action, mods_name_target)
        
    end

    def the(mods_name)
    end

    def extend()
    end

    def throw()
    end
end


class Architecture < DCL
    mod :A, "A.*"
    mod :BC, "B.*", "C.*"
end
=end

puts Module.constants()

require "ruby18_parse"

puts Module.constants()

