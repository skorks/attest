module Attest
  module Output
    class BasicOutputWriter
      def initialize
        @containers = []
      end

      def before_everything
      end

      def before_context(container)
        @containers << container
        puts "#{Attest.current_file}:"
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
        if relevant_result && relevant_result.error?
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
        tests, success, failure, error = 0, 0, 0, 0
        @containers.each do |container|
          container.test_objects.each do |test_object|
            tests += 1
            test_object.results.each do |result|
              if result.success?
                success += 1
              elsif result.failure?
                failure += 1
              else
                error += 1
              end
            end
          end
        end
        puts "Ran #{tests} tests: #{success} successful, #{failure} failed, #{error} errors"
      end

      def after_everything
      end
    end
  end
end
