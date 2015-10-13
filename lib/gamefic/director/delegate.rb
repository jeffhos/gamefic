module Gamefic
  module Director
    class Delegate
      def initialize(actor, orders)
        @actor = actor
        @orders = orders
      end
      def proceed
        order = @orders.shift
        return if order.nil?
        @actor.send(:delegate_stack).push self
        arg_i = 0
        final_arguments = []
        order.arguments.each { |argument|
          if argument.length > 1 and !order.action.queries[arg_i].allow_many?
            # If we use Query::Base.new in the @disambiguator declaration, Opal
            # passes the block to the query instead of the action.
            base = Query::Base.new
            disambiguator = Meta.new nil, nil, base do |actor, entities|
              definites = []
              entities.each { |entity|
                definites.push entity.definitely
              }
              actor.tell "I don't know which you mean: #{definites.join_or}."
            end
            order = Order.new(@actor, disambiguator, [])
            final_arguments = [argument]
            break
          end
          valid = []
          argument.each { |match|
            if order.action.queries[arg_i].validate(@actor, match)
              valid.push match
            end
          }
          if order.action.queries[arg_i].allow_many?
            if valid.length == 1
              proceed
              @actor.send(:delegate_stack).pop
              return
            end
            final_arguments.push valid
          else
            if valid.length == 0
              proceed
              @actor.send(:delegate_stack).pop
              return
            end
            final_arguments.push valid[0]
            arg_i += 1
          end
        }
        # The actor is always the first argument to an Action proc
        final_arguments.unshift @actor
        order.action.execute(*final_arguments)
        @actor.send(:delegate_stack).pop
      end
      def execute
        return if @orders.length == 0
        if !@orders[0].action.kind_of?(Meta)
          @actor.plot.asserts.each_pair { |name, rule|
            result = rule.test(@actor, @orders[0].action.verb, @orders[0].arguments)
            if result == false
              return
            end
          }
        end
        proceed
      end
    end
  end
end
