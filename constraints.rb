
require_relative 'exceptions'


class Constraint
    @mod = nil
    @mod_target = nil

    def initialize(mod, mod_target)
        @mod = mod
        @mod_target = mod_target
    end

    def check(fact)
        raise NotImplementedError, "Method check not implemented"
    end

    def violation
        raise ViolationException, "Violation: #{@mod.name} accessing #{@mod_target.name}"
    end


end


class AccessConstraint < Constraint
    def check(fact)
        puts 'checking fact'
        puts fact
        #puts fact[:object]
        puts
        puts @mod
        puts @mod_target
        puts 'XXXXXXXXXXXXXXXX'
        puts
        puts

        if ! @mod.has(fact[:sender]) and @mod_target.has(fact[:object])
            puts "DEU ERRO"
            puts
            raise ConstraintDoesNotMatchException, "Access of #{fact[:sender]} in #{fact[:object]}"
        end

        return true
    end
end


class CreateConstraint < Constraint
    def check(fact)
        if ! @mod.has(fact[:sender]) and @mod_target.has(fact[:cls])
            raise ConstraintDoesNotMatchException, "Creation of #{fact[:sender]} in #{fact[:cls]}"
        end

        return true
    end

     def violation
        raise ViolationException, "Violation: #{@mod.name} creating #{@mod_target.name}"
    end 
   
end

class ExtendConstraint < Constraint
    def check(fact)
        if ["", "Object", "Class"].index(fact[:parent].name)  == nil
            if ! @mod.has(fact[:cls]) and @mod_target.has(fact[:parent])
                raise ConstraintDoesNotMatchException, "Inheritance of #{fact[:parent]} in #{fact[:cls]}"
            end
        else
            raise ConstraintDoesNotMatchException, "Inheritance of #{fact[:parent]} in #{fact[:cls]}"
        end

        return true
    end

    def violation
        raise ViolationException, "Violation: #{@mod.name} extending #{@mod_target.name}"
    end 

end



if __FILE__ == $0
    $:.unshift File.join(File.dirname(__FILE__),'..')
    $:.unshift File.join(File.dirname(__FILE__),'.')

    require "test/unit"

    class TestRulesList < Test::Unit::TestCase

    end
end
