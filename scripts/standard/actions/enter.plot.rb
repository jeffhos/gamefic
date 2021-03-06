respond :enter, Use.siblings(Enterable, :enterable?) do |actor, supporter|
  actor.parent = supporter
  actor.tell "#{you.pronoun.Subj} #{you.verb[supporter.enter_verb]} #{the supporter}."
end

respond :enter, Use.siblings(Enterable, Openable, :enterable?) do |actor, container|
  if container.open?
    actor.proceed
  else
    actor.tell "#{The container} is closed."
  end
end

respond :enter, Use.siblings do |actor, thing|
  actor.tell "#{The thing} #{you.contract "can not"} accommodate #{you.pronoun.obj}."
end

respond :enter, Use.parent do |actor, container|
  actor.tell "#{you.contract(you.pronoun.subj + ' ' + you.verb.be).cap_first} already in #{the container}."
end

respond :enter, Use.parent(Supporter) do |actor, supporter|
  actor.tell "#{you.pronoun.Subj} #{you.verb[supporter.enter_verb]} #{the supporter} already."
end

respond :enter, Use.text do |actor, text|
  actor.tell "#{you.pronoun.Subj} #{you.contract(you.verb.do + ' not')} see any \"#{text}\" here."
end

interpret "get on :thing", "enter :thing"
interpret "get in :thing", "enter :thing"
