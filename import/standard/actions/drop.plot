respond :drop, Query::Visible.new() do |actor, thing|
  actor.tell "You're not carrying #{the thing}."
end

respond :drop, Query::Children.new() do |actor, thing|
  thing.parent = actor.parent
  actor.tell "You drop #{the thing}."
end

respond :drop, Use.many_visible do |actor, things|
  things.each { |thing|
    actor.perform :drop, thing
  }
end

respond :drop, Use.text("all", "everything") do |actor, text|
  children = actor.children.that_are_not(:attached?)
  if children.length == 0
    actor.tell "You don't have anything to drop."
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
      actor.tell "You drop #{dropped.join_and}."
    end
  end
end

respond :drop, Use.text("all", "everything"), Use.text("but", "except"), Use.children do |actor, text1, text2, exception|
  children = actor.children.that_are_not(:attached?)
  if children.length == 0
    actor.tell "You don't have anything to drop."
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
      actor.tell "You drop #{dropped.join_and}."
    end
  end
end

respond :drop, Use.text("all", "everything"), Use.text("but", "except"), Use.many_visible do |actor, text1, text2, exceptions|
  children = actor.children.that_are_not(:attached?)
  if children.length == 0
    actor.tell "You don't have anything to drop."
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
      actor.tell "You drop #{dropped.join_and}."
    end
  end
end

respond :drop, Use.text("all", "everything", "anything", "any", "every", "each"), Use.ambiguous_visible do |actor, text1, things|
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
    actor.tell "You drop #{dropped.join_and}."
  end
end

respond :drop, Use.text("all", "everything", "anything", "any", "every", "each"), Use.ambiguous_visible, Use.text("except", "but"), Use.ambiguous_visible do |actor, _, things, _, exceptions|
  actor.perform :drop, things - exceptions
end

#respond :drop, Use.text("all", "everything", "anything", "any", "every", "each"), Use.ambiguous_visible, Use.text("except", "but"), Use.text do |actor, _, things, _, exceptions|
#  actor.tell "I don't see anything \"#{exceptions}\" to exclude here."
#end

interpret "put down :thing", "drop :thing"
interpret "put :thing down", "drop :thing"
