respond :open, Query::Text.new() do |actor, string|
  actor.tell "You don't see any \"#{string}\" here."
end

respond :open, Query::Reachable.new(Entity) do |actor, thing|
  actor.tell "You can't open #{the thing}."
end

respond :open, Query::Reachable.new(Container, :openable) do |actor, container|
  if container.is? :closed
    actor.tell "You open #{the container}."
    container.is :open
  else
    actor.tell "It's already open."
  end
end
