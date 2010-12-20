require 'attest/output/output_writer_interface'
require 'attest/expectation_result'

module Attest
  module Output
    class OutputWriter
      include OutputWriterInterface
      def initialize
        self.instance_variable_set("@containers", [])
        self.instance_variable_set("@start_time", nil)
        self.instance_variable_set("@end_time", nil)
      end

      def before_all_tests
        @start_time = Time.now
      end
      def after_all_tests
        @end_time = Time.now
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
        print "#{test_count} tests #{expectation_status_hash.inject(0){|sum, tuple| sum + tuple[1]}} expectations"
        Attest::ExpectationResult.status_weights.sort{|a, b| a[1] <=> b[1]}.each {|status, weight| print " #{expectation_status_hash[status]} #{status.to_s}"}
        puts
        puts "Finished in #{elapsed_time(@end_time, @start_time)}"
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
      def elapsed_time(end_time, start_time)
        units = ["milliseconds", "seconds", "minutes", "hours"]
        elapsed_seconds = end_time - start_time
        if elapsed_seconds < 1
          elapsed_time_as_string = "#{round_to(2, (elapsed_seconds * 1000))} #{units[0]}"
        elsif elapsed_seconds >= 1 && elapsed_seconds < 60
          elapsed_time_as_string = "#{round_to(2, elapsed_seconds)} #{units[1]}"
        elsif elapsed_seconds >= 60 && elapsed_seconds < 3600
          minsec = elapsed_seconds.divmod(60).collect{|num| round_to(2, num)}
          elapsed_time_as_string = "#{minsec[0]} #{units[2]}, #{minsec[1]} #{units[1]}"
        else
          minsec = elapsed_seconds.divmod(60).collect{|num| round_to(2, num)}
          hourminsec = minsec[0].divmod(60).collect{|num| round_to(2, num)}
          hourminsec << minsec[1]
          elapsed_time_as_string = "#{hourminsec[0]} #{units[3]}, #{hourminsec[1]} #{units[2]}, #{hourminsec[2]} #{units[1]}"
        end
        elapsed_time_as_string
      end

      def round_to(decimal_places, number)
        rounded = (number * 10**decimal_places).round.to_f / 10**decimal_places 
        rounded_as_int = (rounded == rounded.to_i ? rounded.to_i : rounded)
        rounded_as_int
      end

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
