module Attest
  class ExecutionContext
    as_itself :should_raise

    self.as_itself(method_name)
    #maybe make this one a class extension mixin
    #alias the method name as old_method_name, redefine method_name 
    #take the output of the method as a tuple [object, result]
    #create an Itself object with the object as self and the result as an indicator of result
    end
    #when method call finishes wrap the output in an Itself object
    def should_raise(type=nil, &block)
      begin
        if block_given?
          yield
        end
      rescue => e
        if type
          return true if e.class == type
        else
          return true
        end
      end
      false
    end

    #def should_not_raise(type=nil, &block)
      #!should_raise(&block)
    #end

    #def should_be_true(&block)
      #result = yield
      #if result == true
        #Attest::Itself.new(result, Attest::Itself.STATES[:success]) 
      #else
        #Attest::Itself.new(result, Attest::Itself.STATES[:fail]) 
      #end
    #end
    
    #def should_not_be_true(&block)
      #!should_be_true(&block)
    #end

    #def should_fail(message="Deliberate fail!")
      ##error = Attest::AttestError.new message
      #Attest::Itself.new(message, Attest::Itself.STATES[:fail])
    #end

    #alias fail should_fail
  end
end
