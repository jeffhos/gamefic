module Gamefic

  class Engine
    def initialize(plot)
      @plot = plot
      post_initialize
    end
    def post_initialize
      @user = User.new @plot
    end
    def run
      @plot.introduce @user.character
      print @user.state.output
      while !@plot.concluded?(@user.character)
        turn
      end
      print @user.state.output
    end
    def turn
      @plot.ready
      print @user.state.output
      if !@user.character[:test_queue].nil? and @user.character[:test_queue].length > 0
        test_command = @user.character[:test_queue].shift
        @user.character.tell "[TESTING] #{@plot.scenes[@user.character.scene].prompt} #{test_command}"
        @user.character.queue.push test_command 
      else
        @user.stream.select @plot.scenes[@user.character.scene].prompt
        @user.state.input
      end
      @plot.update
      print @user.state.output
    end
  end

  class User
    attr_reader :state, :character, :story
    def initialize(plot)
      @plot = plot
      @character = Character.new @plot, :name => 'yourself', :synonyms => 'self myself you me', :proper_named => true
      @character.connect self
      post_initialize
    end
    def post_initialize
      @stream = UserStream.new
      @state = UserState.new self
    end
    def stream
      @stream ||= UserStream.new
    end
    def state
      @state ||= UserState.new(self)
    end
    def state=(state_class)
      @state = state_class.new self
    end
    def refresh
      # Nothing to do
    end
    def quit
      #exit
    end
  end
  
  class UserStream
    def initialize
      @queue = Array.new
      @buffer = ''
    end
    def flush
      tmp = @buffer.clone
      #@buffer.clear
      @buffer = ''
      tmp
    end
    def send(data)
      # Quick and dirty HTML sanitization
      #data.gsub!(/<[a-z]+[^>]*>/i, "")
      #data.gsub!(/<\/[^>]*>/, "")
      @buffer += data
    end
    def select(prompt)
      print "#{prompt} "
      STDOUT.flush
      line = STDIN.gets
      @queue.push line.strip
    end
    def recv
      @queue.shift
    end
  end
  
  class UserState
    attr_reader :user
    def initialize(user)
      @user = user
    end
    def input
      line = @user.stream.recv
      if line != nil
        @user.character.queue.push line
      end
    end
    def output
      @user.stream.flush
    end
  end

end
