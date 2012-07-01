=begin 
    Example of rules:
     - Only X can-access X
     - The X can-access X

    Basic Syntax of a Rule:
    RULE_TYPE MODULE_ORIGIN CHECK_RULE MODULE_TARGET
    where:
     - RULE_TYPE: "only" or "the"
     - MODULE_ORIGIN: isntance of ModuleDef, represents a module
     - CHECK_RULE: means the type of verification in the rule. Defined by the
       CheckRule classes
     - MODULE_TARGET: instance of ModuleDef, means the module 
=end

=begin
A list of rules.
=end

require_relative "constraints"

class RulesList < Array
    @rules = []

    def initialize(rules=[])
        @rules = rules
        super(rules)
    end

    # Filter the list of rules by the type of interaction they represent
    def get_by_type(type)
        facts2typerule = {:methodcall => [:cant_access, :can_access],
                          :inheritance => [:cant_extend, :can_extend],
                          :objcreation => [:cant_create, :can_create]}

        find_all { |x| facts2typerule[type].index(x.type_interaction) != nil  }
    end

end

# Base class of a rule
class Rule
    attr_accessor :type_interaction
    @type_interaction = nil
    @mod_name = nil
    @mod_target = nil
    @constraint = nil
    @modifier = nil

    def initialize(mod_name, type_interaction, mod_target)
        @mod_name = mod_name
        @type_interaction = type_interaction
        @mod_target = mod_target

        # Defining the constraint class
        @modifier, constraint = @type_interaction.to_s.split('_')
        @constraint = get_constraint_class(constraint).new(@mod_name, @mod_target)

        if @modifier == "can"
            @modifier = Proc.new { |x| x }
        else
            @modifier = Proc.new { |x| not x }        
        end
    end

    def verify(fact)
        fact_validation = @constraint.check(fact)

        if not @modifier.call fact_validation
            @constraint.violation()
        end
    end

    def to_s
        "#{@mod_name} #{@type_interaction} #{@mod_target}"
    end

    # From the type of rule (can_access|can_create|etc) returns the class of rule
    def get_constraint_class(type)
        {:access => AccessConstraint,
         :create => CreateConstraint,
         :extend => ExtendConstraint}[type.to_sym]
    end

end

# Defines the most simple rule, without restrictions
class TheRule < Rule
end


# Defines a rule that restricts the fact to one module
class OnlyRule < Rule
    def verify(fact)
        # Aplicar only
        super(fact)
    end
end



if __FILE__ == $0
    $:.unshift File.join(File.dirname(__FILE__),'..')
    $:.unshift File.join(File.dirname(__FILE__),'.')

    require "test/unit"

    class TestRulesList < Test::Unit::TestCase

        def test_getbytype
            list = RulesList.new(
                [TheRule.new(:view, :cant_access, :model),
                TheRule.new(:view, :cant_extend, :controller),
                TheRule.new(:view, :cant_access, :model),
                TheRule.new(:view, :cant_create, :util)]
            )

            assert(list.get_by_type(:methodcall).length == 2, 'Qtd de elementos filtrados de RuleList errada')
            assert(list.get_by_type(:inheritance).length == 1, 'Qtd de elementos filtrados de RuleList errada')
            assert(list.get_by_type(:objcreation).length == 1, 'Qtd de elementos filtrados de RuleList errada')
        end

        def test_get_constraint_class
            rule = Rule.new(:a, :can_create, :b)
            assert(rule.get_constraint_class(:access) == AccessConstraint, "Should be return ConstraintAccess")
            assert(rule.get_constraint_class(:create) == CreateConstraint, "Should be return ConstraintCreate")
            assert(rule.get_constraint_class(:extend) == ExtendConstraint, "Should be return ConstraintExtend")
        end
    end
end


