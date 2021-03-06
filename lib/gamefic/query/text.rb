module Gamefic::Query
  class Text < Base
    def base_specificity
      10
    end
    def validate(subject, description)
      return false unless description.kind_of?(String)
      valid = false
      words = description.split_words
      words.each { |word|
        if description.include?(word)
          valid = true
          break
        end
      }
      valid
    end
    def execute(subject, description)
      if @arguments.length == 0
        return Matches.new([description], description, '')
      end
      keywords = Keywords.new(description)
      args = Keywords.new(@arguments)
      found = Array.new
      remainder = keywords.clone
      while remainder.length > 0
        if args.include?(remainder.first)
          found.push remainder.shift
        else
          break
        end
      end
      if found.length > 0
        return Matches.new(found, found.join(' '), remainder.join(' '))
      else
        return Matches.new([], '', description)
      end
    end
    def test_arguments arguments
      # No test for text
    end
  end
end
