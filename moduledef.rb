require_relative 'modulecache'



=begin
    A ModuleDef represents a logical module on DCL. The constraints on DCL are
    defined upon the ModuleDef objects
=end
class ModuleDef
    attr_accessor :name, :paths
    @name = ''
    @paths = []
    @loaded = false

    def initialize(name, paths)
        # Defines the main variables and caches all the names associated with 
        # the modules
        @name = name
        @paths = paths
        @loaded = false

        self.load
    end

    # Loads modules in this moduledef to use 
    def load        
        @paths.each do |mod_name|
            globals_of_module(mod_name)
        end
        @loaded = true
    end

    def has(cls)
        # We need to lazy load the modules, otherwise, all modules will be
        # loaded and his code wouldnt be instrumented
        if not @loaded
            load
        end

        # Given a class, discover if self contains it
        valids = @paths.find_all { |x| ModuleCache.get_mod(x, cls.class.name) != []}
        valids != []
    end

    def to_s
        "#<ModuleDef: name=>#{@name},  paths=>#{@paths}>"
    end
end




if __FILE__ == $0
    $:.unshift File.join(File.dirname(__FILE__),'..')
    $:.unshift File.join(File.dirname(__FILE__),'.')


    #require_relative 'system/model'
    #require_relative 'system/view'

    view = ModuleDef.new(:A, ['system/view'])
    mod = ModuleDef.new(:B, ['system/model'])

    puts view.has(ModuleIncluded)
    puts mod.has(ModuleIncluded)
end

