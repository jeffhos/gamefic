require 'gamefic/command'

module Gamefic

  class Syntax
    attr_reader :token_count, :first_word, :verb, :template, :command
    @@phrase = '([\w\W\s\S]*?)'
    
    def initialize plot, template, *command
      command = command.join(' ')
      words = template.split_words
      @token_count = words.length
      command_words = command.split_words
      @verb = nil
      if words[0][0] == ':'
        @token_count -= 1
        @first_word = ''
      else
        @verb = command_words[0].to_sym if !command_words[0].nil?
        @first_word = words[0].to_s
      end
      @command = command_words.join(' ')
      @template = words.join(' ')
      tokens = []
      variable_tokens = []
      last_token_is_reg = false
      words.each { |w|
        if w.match(/^:[a-z0-9_]+$/i)
          variable_tokens.push w
          if last_token_is_reg
            next
          else
            tokens.push @@phrase
            last_token_is_reg = true
          end
        else
          tokens.push w
          last_token_is_reg = false
        end
      }
      subs = []
      index = 0
      command_words.each { |t|
        if t[0] == ':'
          index = variable_tokens.index(t) + 1
          subs.push "{$#{index}}"
        else
          subs.push t
        end
      }
      @replace = subs.join(' ')
      @regexp = Regexp.new("^#{tokens.join(' ')}$", Regexp::IGNORECASE)
      if !plot.nil?
        plot.send :add_syntax, self
      end
    end
    
    # Convert a String into a Command.
    #
    # @param text [String]
    # @return [Command]
    def tokenize text
      m = text.match(@regexp)
      return nil if m.nil?
      arguments = []
      @replace.to_s.split_words.each { |r|
        if r.match(/^\{\$[0-9]+\}$/)
          arguments.push m[r[2..-2].to_i]
        else
          arguments.push r
        end
      }
      Command.new @verb, arguments
    end
    
    # Get a signature that identifies the form of the Syntax.
    # Signatures are used to compare Syntaxes to each other.
    #
    def signature
      [@regexp, @replace]
    end
    
    def ==(other)
      signature == other.signature
    end
    
    # Tokenize an Array of Commands from the specified text.
    #
    # @param text [String] The text to tokenize.
    # @param syntaxes [Array<Syntax>] The Syntaxes to use.
    # @return [Array<Command>] The tokenized commands.
    def self.tokenize text, syntaxes
      matches = []
      syntaxes.each { |syntax|
        result = syntax.tokenize text
        matches.push(result) if !result.nil?
      }
      # Sort matches having the most populated arguments first
      matches.sort! { |a, b|
        ca = 0
        cb = 0
        a.arguments.each { |t|
          break if t.nil?
          ca += 1
        }
        b.arguments.each { |t|
          break if t.nil?
          cb += 1
        }
        cb <=> ca
      }
      matches      
    end
  end

end
