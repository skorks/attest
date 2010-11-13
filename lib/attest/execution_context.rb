module Attest
  class ExecutionContext
    attr_reader :results
    #create a class macro whereby if the subject is self should throw a no method error for the methods supplied
    #called_on_subject :should_equal

    #class << self
      #def called_on_subject(*args)
      #end
    #end

    def initialize
      @results = []
      @subject = self
    end

    def should_raise(type=nil, &block)
      @results << Attest::ExpectationResult.new
      result = @results.last
      begin
        if block_given?
          yield
        end
      rescue => e
        if type && type == e.class
          result.success
        else
          result.success
        end
      end
      #either no error was raised or it was an error type mismatch
      result.failure if !result.success?
      #result.context = current_method
      #result.actual_error_object = e
      #result.expected_error = type
      self
    end

    def with_message(regex)
      result = @results.last
      raise Attest::AttestError.new "#{current_method} can't be called on that object" if result.context != "should_raise"
      if(!(result.actual_error_object.message =~ regex) && result.success?)
        #an error message mismatch
        result.failure
        #result.expected_error_message = regex
        #result.context = current_method
      end
    end

    def should_fail
      @results << Attest::ExpectationResult.new
      result = @results.last
      result.failure
      self
    end

    def should_be_true(&block)
      @results << Attest::ExpectationResult.new
      result = @results.last
      block_return = yield
      if block_return
        result.success
      else
        result.failure
      end
      self
    end

    def should_not_raise(&block)
      should_raise(&block)
      result = @results.last
      if result.success?
        result.failure
      else
        result.success
      end
      self
    end

    def should_not_be_true(&block)
      should_be_true(&block)
      result = @results.last
      if result.success?
        result.failure
      else
        result.success
      end
      self
    end




















    #def should_equal(an_object)
      #raise Attest::AttestError.new "#{current_method} must be called on an object" if @subject == self
      #@results << Attest::AssertionResult.new
      #result = @results.last
      #result.context = current_method
      #if @subject == an_object
        #result.success
      #else
        #result.failure
      #end
      #result.expected = an_object
      #result.actual = @subject
      #self
    #end

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
