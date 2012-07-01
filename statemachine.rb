=begin
    The main state machine  
=end
require_relative 'rules'

require_relative 'exceptions'



module DCL
    attr_accessor :mods, :facts, :rules
    @rules = RulesList.new 
    @facts = []
    @mods = {}

    def self.mods
        mods
    end

    def self.insert_mod(moddef)
        @mods[moddef.name] = moddef
    end

    def self.get_mod(mod_name)
        @mods[mod_name]
    end

    def self.insert_rule(rule)
        @rules.push rule
    end

    # When any fact occurs, we validate the new fact upon all the system's 
    # restrictions
    def self.verify_rules(fact)
        #p '<---------------------------------'
        #p fact
        rules = @rules.get_by_type(fact[:type])
        #p @rules
        #p '---------------------------------/>'

        rules.each do |rule|
            begin
                rule.verify(fact)
            rescue ViolationException => e
                puts e
            rescue ConstraintDoesNotMatchException => e
                #puts e
            end
        end     
    end

    # Signal launched by the FactLogger
    def self.notify_fact(fact)
        #p "NEW FACT: #{fact}"
        verify_rules(fact)
    end


end



if __FILE__ == $0
    $:.unshift File.join(File.dirname(__FILE__),'..')
    $:.unshift File.join(File.dirname(__FILE__),'.')

end
