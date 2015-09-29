require 'json'

module Gamefic
  class Snapshots
    attr_accessor :history
    def initialize entities
      @history = []
      @entities = entities
    end
    def save entities
      store = []
      index = 0
      entities.each { |e|
        hash = {}
        e.serialized_attributes.each {|m|
          con = m.to_s
          if con.end_with?("?")
            con = con[0..-2]
          end
          if e.respond_to?(m) == true
            begin
              xxx = e.send(m)
              if xxx == false
                hash[con] = false
              elsif xxx
                hash[con] = serialize_obj(xxx)
              else
                hash[con] = nil
              end
            rescue Exception => error
              hash[con] = nil
            end
          end
        }
        hash[:session] = {}
        e.session.each_pair { |k, v|
          hash[:session][k] = serialize_obj(v)
        }
        store.push hash
        index += 1
      }
      if @history.length > 10
        @history.shift
      end
      json = JSON.generate(store)
      #puts json
      json
    end
    def restore snapshot
      data = JSON.parse(snapshot)
      index = 0
      data.each { |hash|
        hash.each_pair { |k, v|
          @entities[index].send("#{k}=", unserialize(v)) if k.to_s != "session"
        }
        #unser = unserialize(hash["session"])
        hash["session"].each_pair { |k, v|
            @entities[index].session[k.to_sym] = unserialize(v)
        }
        index += 1
      }
    end
    def blacklist
      [:children, :session, :scene, :object_of_pronoun, :test_queue, :test_queue_scene, :test_queue_length, :testing]
    end
    private
    def can_serialize? obj
      return true if (obj == true or obj == false or obj.nil?)
      allowed = [String, Fixnum, Float, Numeric, Entity, Direction, Hash, Array, Symbol]
      allowed.each { |a|
        return true if obj.kind_of?(a)
      }
      false
    end
    def serialize_obj obj
      return nil if obj.nil?
      return false if obj == false
      if obj.kind_of?(Hash)
        hash = {}
        obj.each_pair { |k, v|
          if can_serialize?(k) and can_serialize?(v)
            hash[serialize_obj(k)] = serialize_obj(v)
          end
        }
        return hash
      elsif obj.kind_of?(Array)
        arr = []
        obj.each_index { |i|
          if can_serialize?(obj[i])
            arr[i] = serialize_obj(obj[i])
          else
            raise "Bad array in snapshot"
          end
        }
        return arr
      else
        if obj.kind_of?(Entity)
          return "#<EIN_#{@entities.index(obj)}>"
        elsif obj.kind_of?(Direction)
          return "#<DIR_#{obj.name}>"
        #elsif obj.kind_of?(Symbol)
        #  return "#<SYM_#{obj.to_s}>"
        end
      end
      return obj
    end
    def unserialize obj
      if obj.kind_of?(Hash)
        hash = {}
        obj.each_pair { |k, v|
          hash[unserialize(k)] = unserialize(v)
        }
        hash
      elsif obj.kind_of?(Array)
        arr = []
        obj.each_index { |i|
          arr[i] = unserialize(obj[i])
        }
        arr
      else
        if obj.to_s.match(/^#<EIN_[0-9]+>$/)
          i = obj[6..-2].to_i
          @entities[i]
        elsif obj.to_s.match(/^#<DIR_[a-z]+>$/)
          Direction.find(obj[6..-2])
        #elsif obj.to_s.match(/^#<SYM_[a-z]+>$/)
        #  Direction.find(obj[6..-2].to_sym)
        else
          obj
        end
      end
    end
  end
end