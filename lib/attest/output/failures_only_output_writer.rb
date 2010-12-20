require 'stringio'
require 'attest/output/output_writer'
require 'attest/expectation_result'

module Attest
  module Output
    class FailuresOnlyOutputWriter < Attest::Output::OutputWriter
      def initialize
        super()
        @relevant_outputs = StringIO.new
      end

      def after_all_tests
        super
        @relevant_outputs.rewind
        2.times {puts}
        puts @relevant_outputs.readlines
      end

      def before_container(container)
        previous_container = @containers.last
        @containers << container
      end

      def after_test(test_object)
        relevant_result = determine_relevant_result test_object
        if relevant_result && relevant_result.failure?
          @relevant_outputs.puts "#{@containers.last.file}"
          @relevant_outputs.puts " #{@containers.last.description}"
          @relevant_outputs.puts "  - #{test_object.description} [#{relevant_result.status.upcase}]"
          @relevant_outputs.puts "  #{relevant_result.source_location}"
          @relevant_outputs.puts
        elsif relevant_result && relevant_result.error?
          e = relevant_result.attributes[:unexpected_error]
          @relevant_outputs.puts "#{@containers.last.file}"
          @relevant_outputs.puts " #{@containers.last.description}"
          @relevant_outputs.puts "  - #{test_object.description} [#{relevant_result.status.upcase}]"
          @relevant_outputs.puts "  #{e.class}: #{e.message}"
          e.backtrace.each do |line|
            @relevant_outputs.puts "   #{line} "
          end
          @relevant_outputs.puts
        end
      end
    end
  end
end
