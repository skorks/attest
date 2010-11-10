module Attest
  class Itself
    STATES={:success => :success, :fail => :fail, :error => :error, :processing => :processing}

    def initialize(object, state = Attest::Itself.STATES[:processing])
      @itself = object
      @state = state
    end

    #when error is set, if it is a child of an exception or is an exception itself then with_message is available, otherwise it is not and shoudl throw a no method

    def with_message(regex)
      raise NoMethodError if !@itself.kind_of?(Exception)
      if @itself.message =~ regex
        @state = Attest::Itself.STATES[:success]
      end
    end

    #def should_equal(another_object)
      #@itself == another_object
    #end

    #def should_not_equal(another_object)
      #@itself != another_object
    #end

    #should_be_true
    #should_not_be_true
    #should_equal
    #should_not_equal
    #should_be_same
    #should_not_be_same
    #with_message if itself is an error object
  end
end
