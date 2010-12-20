require 'attest/output/output_writer_interface'
require 'attest/expectation_result'

module Attest
  module Output
    class OutputWriter
      include OutputWriterInterface
      def initialize
        self.instance_variable_set("@containers", [])
      end

      def before_all_tests
      end
      def after_all_tests
      end
      def before_container(container)
      end
      def after_container(container)
      end
      def before_test(test_object)
      end
      def after_test(test_object)
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
      def ignore_container(container)
        if @containers.last.object_id == container.object_id
          @containers.delete @containers.last 
        else 
          @containers.delete_if {|current_container| current_container.object_id == container.object_id}
        end
      end
      def an_error(error_object)
        puts "#{error_object.class}: #{error_object.message}"
        error_object.backtrace.each do |line|
          puts " #{line} "
        end
      end

      private
      def determine_relevant_result(test_object)
        relevant_result = nil
        test_object.results.each do |result|
          relevant_result = result unless result.success?
        end
        relevant_result
      end

      def determine_test_status(test_object)
        expectation_status_hash = blank_status_hash
        overall_test_status_hash = blank_status_hash
        dominant_result = nil
        test_object.results.each do |result|
          expectation_status_hash[result.status.to_sym] += 1
          dominant_result = result if result > dominant_result
        end
        raise "Unexpected result status encountered! WTF!!!" if expectation_status_hash.keys.size > Attest::ExpectationResult.status_types.size
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
