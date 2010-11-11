module Attest
  class TestObject
    def initialize(description, test_block)
      @description = description
      @test_block = test_block
      @before = nil
      @after = nil
    end

    def add_setup(block)
      @before = block
    end

    def add_cleanup(block)
      @after = block
    end

    def run
      #evaling the block should produce a result which will be either an Itself object or not
      #if it is not an itself object then it should be wrapped in an itself object, it can be an error in which case the error should be wraped
      #it may be the fact that none of the should methods were called in which case it may be treated as a success
      
      begin
       context = Attest::ExecutionContext.new
       Object.class_eval do
         define_method :itself do
           subject = self
           context.instance_eval {@subject = subject}
           context
         end
       end
       context.instance_eval(&@before) if @before
       context.instance_eval(&@test_block)
       context.instance_eval(&@after) if @after
      rescue => e
        puts "ERROR!!!!!"
        puts e.message
        puts e.backtrace.inspect
      ensure
        overall = nil
        context.results.each do |result| 
          overall = result if !result.success?
        end
        puts " - #{description} #{'FAIL' if overall}"
      end
      #puts " - #{description} #{extra_output}"
      #if error
       #puts "     #{e.class}: #{e.message}"
       #e.backtrace.each do |line|
         #break if line =~ /#{__FILE__}/
         #puts "     #{line} "
       #end
      #end
    end
  end
end
