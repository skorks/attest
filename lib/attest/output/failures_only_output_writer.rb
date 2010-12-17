require 'stringio'

module Attest
  module Output
    class FailuresOnlyOutputWriter
      def initialize
        @containers = []
        @relevant_outputs = StringIO.new
      end

      def before_everything
      end

      def before_context(container)
        previous_container = @containers.last
        @containers << container
        #puts "#{container.file}:" unless previous_container && previous_container.file == container.file
        #puts " #{ container.description }"
      end

      def before_test(test_object)
        #print "  - #{test_object.description}"
      end

      def after_test(test_object)
        relevant_result = nil
        test_object.results.each do |result|
          relevant_result = result if !result.success?
        end
        #print '.' unless relevant_result
        #print "#{relevant_result.status.upcase[0]}" if relevant_result
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

      def after_context
        #puts 
      end

      def summary
        return unless @containers.size >= 1
        expectation_status_hash = blank_status_hash
        overall_test_status_hash = blank_status_hash
        test_count = 0
        @containers.each do |container|
          container.test_objects.each do |test_object|
            test_count += 1
            current_test_statuses = determine_test_status test_object
            overall_test_status_hash = merge_counting_hashes(overall_test_status_hash, current_test_statuses[0])
            expectation_status_hash = merge_counting_hashes(expectation_status_hash, current_test_statuses[1])
          end
        end
        puts
        print "#{test_count} tests #{expectation_status_hash.inject(0){|sum, tuple| sum + tuple[1]}} assertions"
        Attest::ExpectationResult.status_weights.sort{|a, b| a[1] <=> b[1]}.each {|status, weight| print " #{expectation_status_hash[status]} #{status.to_s}"}
        puts
      end

      def after_everything
        @relevant_outputs.rewind
        2.times {puts}
        puts @relevant_outputs.readlines
      end

      def error(e)
      end

      private
      def determine_test_status(test_object)
        expectation_status_hash = blank_status_hash
        overall_test_status_hash = blank_status_hash
        dominant_result = nil
        test_object.results.each do |result|
          expectation_status_hash[result.status.to_sym] += 1
          dominant_result = result if result > dominant_result
        end
        raise "Unexpected result status encountered! WTF!!!" if expectation_status_hash.keys.size > 4
        raise "Test without status encountered, all test should have a status!" unless dominant_result 
        overall_test_status_hash[dominant_result.status.to_sym] += 1
        [overall_test_status_hash, expectation_status_hash]
      end

      def merge_counting_hashes(hash1, hash2)
        hash1.inject(hash2) do |accumulator_hash, tuple|
          accumulator_hash[tuple[0]] += tuple[1]
          accumulator_hash
        end
      end

      def blank_status_hash
        Attest::ExpectationResult.status_types.inject({}) do |accumulator, status|
          accumulator[status] = 0 
          accumulator
        end
      end
    end
  end
end
