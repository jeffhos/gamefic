require 'gamefic'

module Gamefic::Sdk::Debug
  class Plot < Gamefic::Plot
    attr_reader :main_dir
    def post_initialize
      meta :debug, Query::Text.new("unused") do |actor, text|
        unused = []
        actions.each { |a|
          if !a.standard? and !a.executed?
            unused.push "#{a.verb}:#{a.source_location}"
          end
        }
        actor.tell "#{unused.join("\r\n")}"
      end
    end
    def action(command, *queries, &proc)
      Gamefic::Sdk::Debug::Action.new(self, command, *queries, &proc)
    end
  end
end
