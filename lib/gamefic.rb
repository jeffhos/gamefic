require "gamefic/core_ext/array"
require "gamefic/core_ext/string"
require "gamefic/optionset"
require "gamefic/keywords"
require "gamefic/entity"
require "gamefic/thing"
require "gamefic/character"
require "gamefic/character/state"
require "gamefic/action"
require "gamefic/meta"
require "gamefic/syntax"
require "gamefic/query"
require "gamefic/rule"
require "gamefic/director"
require "gamefic/plot"
require "gamefic/engine"
require "gamefic/direction"

module Gamefic
  GLOBAL_IMPORT_PATH = File.dirname(__FILE__) + "/../import/"
end
