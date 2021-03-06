require 'gamefic/keywords'

module Gamefic

  module Query
    autoload :Base, 'gamefic/query/base'
    autoload :Text, 'gamefic/query/text'
    autoload :Expression, 'gamefic/query/expression'
    autoload :Self, 'gamefic/query/self'
    autoload :Parent, 'gamefic/query/parent'
    autoload :Children, 'gamefic/query/children'
    autoload :ManyChildren, 'gamefic/query/many_children'
    autoload :AmbiguousChildren, 'gamefic/query/ambiguous_children'
    autoload :PluralChildren, 'gamefic/query/plural_children'
    autoload :Siblings, 'gamefic/query/siblings'
    autoload :Family, 'gamefic/query/family'
    autoload :Matches, 'gamefic/query/matches'
    
    def self.allow_plurals?
      if @allow_plurals.nil?
        @allow_plurals = true
      end
      @allow_plurals
    end
    def self.allow_plurals= boolean
      @allow_plurals = boolean
    end
  end

end
