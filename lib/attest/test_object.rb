module Attest
  class TestObject
    attr_reader :description, :results
    def initialize(description, test_block)
      @description = description
      @test_block = test_block
      @before = nil
      @after = nil
      @results = nil
    end

    def add_setup(block)
      @before = block
    end

    def add_cleanup(block)
      @after = block
    end

    def run
      Attest.output_writer.before_test(self)
      error = nil
      context = Attest::ExecutionContext.new
      begin
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
        error = e
      ensure
        @results = context.results
        @results << Attest::ExpectationResult.new(:error => error) if error
      end


      #puts " - #{description} #{extra_output}"
      #if error
       #puts "     #{e.class}: #{e.message}"
       #e.backtrace.each do |line|
         #break if line =~ /#{__FILE__}/
         #puts "     #{line} "
       #end
      #end
      Attest.output_writer.after_test(self)
    end
  end
end
