module Gamefic::Enterable
  attr_writer :enterable
  def enterable?
    @enterable ||= false
  end
end
