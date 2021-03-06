respond :drop, Use.many_children do |actor, things|
  dropped = []
  things.each { |thing|
    buffer = actor.quietly :drop, thing
    if thing.parent == actor
      actor.tell buffer
    else
      dropped.push thing
    end
  }
  if dropped.length > 0
    actor.tell "#{you.pronoun.Subj} drop #{dropped.join_and}."
  end
end

respond :drop, Use.text("all", "everything") do |actor, text|
  children = actor.children.that_are_not(:attached?)
  if children.length == 0
    actor.tell "#{you.pronoun.Subj} #{you.contract(you.verb.do + ' not')} have anything to drop."
  else
    dropped = []
    children.each { |child|
      buffer = actor.quietly :drop, child
      if child.parent != actor
        dropped.push child
      else
        actor.tell buffer
      end
    }
    if dropped.length > 0
      actor.tell "#{you.pronoun.Subj} drop #{dropped.join_and}."
    end
  end
end

respond :drop, Use.text("all", "everything"), Use.text("but", "except"), Use.children do |actor, text1, text2, exception|
  children = actor.children.that_are_not(:attached?)
  if children.length == 0
    actor.tell "#{you.pronoun.Subj} #{you.contract(you.verb.do + ' not')} have anything to drop."
  else
    dropped = []
    children.each { |child|
      next if exception == child
      buffer = actor.quietly :drop, child
      if child.parent != actor
        dropped.push child
      else
        actor.tell buffer
      end
    }
    if dropped.length > 0
      actor.tell "#{you.pronoun.Subj} drop #{dropped.join_and}."
    end
  end
end

respond :drop, Use.text("all", "everything"), Use.text("but", "except"), Use.text do |actor, text1, text2, text3|
  actor.tell "I understand you want to drop #{text1} but don't know what you're trying to exclude with \"#{text3}.\""
end

respond :drop, Use.text("all", "everything"), Use.text("but", "except"), Use.many_children do |actor, text1, text2, exceptions|
  children = actor.children.that_are_not(:attached?)
  if children.length == 0
    actor.tell "#{you.pronoun.Subj} #{you.contract(you.verb.do + ' not')} have anything to drop."
  else
    dropped = []
    children.each { |child|
      next if exceptions.include?(child)
      buffer = actor.quietly :drop, child
      if child.parent != actor
        dropped.push child
      else
        actor.tell buffer
      end
    }
    if dropped.length > 0
      actor.tell "#{you.pronoun.Subj} drop #{dropped.join_and}."
    end
  end
end

respond :drop, Use.text("all", "everything"), Use.text("but", "except"), Use.plural_children do |actor, text1, text2, exceptions|
  children = actor.children.that_are_not(:attached?)
  actor.perform :drop, children - exceptions
end

respond :drop, Use.text("all", "everything"), Use.text("but", "except"), Use.any_expression, Use.ambiguous_children do |actor, text1, text2, text3, exceptions|
  children = actor.children.that_are_not(:attached?)
  actor.perform :drop, children - exceptions
end

respond :drop, Use.any_expression, Use.ambiguous_children do |actor, text1, things|
  filtered = things.clone
  filtered.delete_if{|t| t.parent != actor}
  if filtered.length == 0
    actor.tell "#{you.pronoun.Subj} #{you.contract(you.verb.be + ' not')} carrying anything that matches your terms."
  else
    dropped = []
    things.each { |thing|
      if thing.parent == actor
        buffer = actor.quietly :drop, thing
        if thing.parent == actor
          actor.tell buffer
        else
          dropped.push thing
        end
      end
    }
    if dropped.length > 0
      actor.tell "#{you.pronoun.Subj} #{you.verb.drop} #{dropped.join_and}."
    end
  end
end

respond :drop, Use.any_expression, Use.ambiguous_children, Use.text("except", "but"), Use.any_expression, Use.ambiguous_children do |actor, _, things, _, exceptions|
  actor.perform :drop, things - exceptions
end

respond :drop, Use.not_expression, Use.ambiguous_children do |actor, _, exceptions|
  children = actor.children
  actor.perform :drop, children - exceptions
end

respond :drop, Use.plural_children do |actor, things|
  actor.perform "drop #{things.join(' and ')}"
end
