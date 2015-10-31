respond :take, Use.reachable do |actor, thing|
  actor.tell "You can't take #{the thing}."
end

respond :take, Use.visible do |actor, thing|
  if thing.parent == actor.parent
    actor.proceed
  elsif thing.parent.kind_of?(Container) and !thing.parent.open?
    actor.tell "#{The thing} is inside #{the thing.parent}, which is closed."
  end
end

respond :take, Use.visible do |actor, thing|
  if actor.parent.kind_of?(Supporter) and actor.parent != thing.parent and actor.parent != thing.parent.parent
    actor.tell "You can't reach it from #{the actor.parent}."
  else
    actor.proceed
  end
end

respond :take, Use.reachable(:attached?) do |actor, thing|
  actor.tell "#{The thing} is attached to #{the thing.parent}."
end

respond :take, Use.reachable(Entity, :portable?) do |actor, thing|
  if thing.parent == actor
    actor.tell "You're already carrying #{the thing}."
  else
    if actor.parent != thing.parent
      actor.tell "You take #{the thing} from #{the thing.parent}."
    else
      actor.tell "You take #{the thing}."
    end
    thing.parent = actor
  end
end

respond :take, Use.reachable(Gamefic::Rubble) do |actor, rubble|
  actor.tell "You don't have any use for #{the rubble}."
end

respond :take, Use.text do |actor, text|
  actor.tell "You don't see any \"#{text}\" here."
end

respond :take, Use.many_visible do |actor, things|
  filtered = things.clone
  filtered.delete_if{ |t| t.parent == actor }
  if filtered.length == 0
    output = "There's nothing to take that matches your terms." + (things.length > 0 ? "(You're already carrying #{things.join_and}.)" : '')
    actor.tell output
  else
    taken = []
    filtered.each { |thing|
      buffer = actor.quietly :take, thing
      if thing.parent != actor
        actor.tell buffer
      else
        taken.push thing
      end
    }
    if taken.length > 0
      actor.tell "You take #{taken.join_and}."
    end
  end
end

respond :take, Use.text("all", "everything") do |actor, text|
  children = actor.parent.children.that_are_not(:attached?).that_are(:portable?)
  if actor.parent != actor.room and actor.parent.kind_of?(Supporter)
    children += actor.room.children.that_are_not(:attached?).that_are(:portable?)
  end
  if children.length == 0
    actor.tell "There's nothing obvious to take."
  else
    taken = []
    children.each { |child|
      buffer = actor.quietly :take, child
      if child.parent == actor
        taken.push child
      else
        actor.tell buffer
      end
    }
    if taken.length > 0
      actor.tell "You take #{taken.join_and}."
    end
  end
end

respond :take, Use.text("all", "everything"), Use.text("but", "except"), Use.visible do |actor, text1, text2, exception|
  children = actor.parent.children.that_are_not(:attached?).that_are(:portable?)
  if actor.parent != actor.room and actor.parent.kind_of?(Supporter)
    children += actor.room.children.that_are_not(:attached?).that_are(:portable?)
  end
  if children.length == 0
    actor.tell "There's nothing obvious to take."
  else
    taken = []
    children.each { |child|
      next if exception == child
      buffer = actor.quietly :take, child
      if child.parent == actor
        taken.push child
      else
        actor.tell buffer
      end
    }
    if taken.length > 0
      actor.tell "You take #{taken.join_and}."
    end
  end
end

respond :take, Use.text("all", "everything"), Use.text do |actor, text1, text2|
  actor.tell "I understand that you want to take #{text1} but did not understand \"#{text2}.\""
end

respond :take, Use.any_expression, Use.ambiguous_visible(:portable?) do |actor, text, things|
  filtered = things.clone
  filtered.delete_if{|t| t.parent == actor}
  if filtered.length == 0
    actor.tell "There's nothing to take that matches your terms. (You're already carrying #{things.join_and}.)"
  #elsif filtered.length == 1
  #  actor.proceed
  else
    taken = []
    filtered.each { |thing|
      buffer = actor.quietly :take, thing
      if thing.parent != actor
        actor.tell buffer
      else
        taken.push thing
      end
    }
    if taken.length > 0
      actor.tell "You take #{taken.join_and}."
    end
  end
end

respond :take, Use.any_expression, Use.ambiguous_visible, Use.text("except", "but"), Use.any_expression, Use.ambiguous_visible do |actor, _, things, _, _, exceptions|
  actor.perform :take, things - exceptions
end

respond :take, Use.text("all", "everything"), Use.text("but", "except"), Use.many_visible do |actor, text1, text2, exceptions|
  visible = Use.many_visible.context_from(actor)
  actor.perform :take, visible - exceptions
end

respond :take, Use.text("all", "everything"), Use.text("but", "except"), Use.any_expression, Use.ambiguous_visible do |actor, _, _, _, exceptions|
  visible = Use.many_visible.context_from(actor)
  actor.perform :take, visible - exceptions
end

respond :take, Use.text("all", "everything"), Use.text("but", "except"), Use.text do |actor, _, _, exceptions|
  actor.tell "I don't understand what you're trying to exclude with \"#{exceptions}.\""
end

respond :take, Use.text("all", "everything"), Use.text("but", "except"), Use.plural_visible do |actor, _, _, exceptions|
  visible = Use.visible.context_from(actor)
  actor.perform :take, visible - exceptions
end

respond :take, Use.any_expression, Use.ambiguous_visible, Use.text("except", "but"), Use.visible do |actor, text1, things, text2, exception|
  actor.perform :take, things - [exception]
end

respond :take, Use.any_expression, Use.ambiguous_visible, Use.text("except", "but"), Use.ambiguous_visible do |actor, text1, things, text2, exceptions|
  actor.perform :take, things - exceptions
end

respond :take, Use.any_expression, Use.ambiguous_visible, Use.text("except", "but"), Use.plural_visible do |actor, text1, things, text2, exceptions|
  actor.perform :take, things - exceptions
end

respond :take, Use.any_expression, Use.ambiguous_visible, Use.text("except", "but"), Use.any_expression, Use.ambiguous_visible do |actor, _, things, _, _, exceptions|
  actor.perform :take, things - exceptions
end

respond :take, Use.ambiguous_visible, Use.text("things", "items", "stuff") do |actor, things, _|
  actor.perform :take, things
end

respond :take, Use.plural_visible do |actor, things|
  actor.perform :take, things
end

respond :take, Use.not_expression, Use.ambiguous_visible do |actor, _, exceptions|
  visible = Use.visible.context_from(actor)
  actor.perform :take, visible - exceptions
end

respond :take, Use.text("all", "everything"), Use.from_expression, Use.reachable(Receptacle) do |actor, _, _, receptacle|
  children = receptacle.children.that_are_not(:attached?)
  if children.length == 0
    actor.tell "There's nothing inside #{the receptacle}."
  else
    taken = []
    children.each { |child|
      buffer = actor.quietly :take, child
      if child.parent != actor
        actor.tell buffer
      else
        taken.push child
      end
    }
    if taken.length > 0
      actor.tell "You take #{taken.join_and} from #{the receptacle}."
    end
  end
end

respond :take, Use.text("all","everything"), Use.reachable(Container) do |actor, text, container|
  actor.tell "Here"
  if container.open?
    actor.proceed
  else
    actor.tell "#{The container} is closed."
  end  
end

interpret "get :thing", "take :thing"
interpret "pick up :thing", "take :thing"
interpret "pick :thing up", "take :thing"
interpret "carry :thing", "take :thing"