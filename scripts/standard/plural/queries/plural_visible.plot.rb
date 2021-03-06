script 'standard/plural/queries/ambiguous_visible'

class Gamefic::Query::PluralVisible < Gamefic::Query::AmbiguousVisible
  def execute(subject, description)
    if (!description.end_with?("s") and !description.end_with?("i") and !description.end_with?("ae")) or (description.end_with?("ous") or description.end_with?("ess"))
      return Gamefic::Query::Matches.new([], '', description)
    end
    super
  end
  def validate(subject, object)
    # Plural queries always return false on validation. Their only purpose is
    # to provide syntactic sugar for plural nouns, so it should never get triggered
    # by a token call.
    false
  end
end

module Gamefic::Use
  def self.plural_visible *args
    Gamefic::Query::PluralVisible.new *args
  end
end
