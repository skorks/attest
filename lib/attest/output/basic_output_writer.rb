module Attest
  module Output
    class BasicOutputWriter
      def initialize
        @containers = []
      end

      def before_everything
      end

      def before_context(container)
        previous_container = @containers.last
        @containers << container
        puts "#{container.file}:" unless previous_container && previous_container.file == container.file
        puts " #{ container.description }"
      end

      def before_test(test_object)
        print "  - #{test_object.description}"
      end

      def after_test(test_object)
        relevant_result = nil
        test_object.results.each do |result|
          relevant_result = result if !result.success?
        end
        print " [#{relevant_result.status.upcase}]" if relevant_result
        if relevant_result && relevant_result.failure?
          2.times { puts } 
          puts "     Possible failure location: #{relevant_result.source_location}"
        elsif relevant_result && relevant_result.error?
          e = relevant_result.attributes[:unexpected_error]
          2.times { puts } 
          puts "     #{e.class}: #{e.message}"
          e.backtrace.each do |line|
            break if line =~ /lib\/attest/
              puts "     #{line} "
          end
        end
        puts
      end

      def after_context
        puts 
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
        print "Total #{test_count} tests:"
        Attest::ExpectationResult.status_weights.sort{|a, b| a[1] <=> b[1]}.each {|status, weight| print " #{overall_test_status_hash[status]} #{status.to_s}"}
        puts
        print "Total #{expectation_status_hash.inject(0){|sum, tuple| sum + tuple[1]}} assertions:"
        Attest::ExpectationResult.status_weights.sort{|a, b| a[1] <=> b[1]}.each {|status, weight| print " #{expectation_status_hash[status]} #{status.to_s}"}
        puts
      end

      def after_everything
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
