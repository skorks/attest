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
      end

      def summary
        return unless @containers.size >= 1
        tests, success, failure, error, pending = 0, 0, 0, 0, 0
        @containers.each do |container|
          container.test_objects.each do |test_object|
            tests += 1
            test_object.results.each do |result|
              if result.success?
                success += 1
              elsif result.failure?
                failure += 1
              elsif result.error?
                error += 1
              elsif result.pending?
                pending += 1
              else
                raise "Errr, WTF!!!"
              end
            end
          end
        end
        puts
        puts "Ran #{tests} tests: #{success} successful, #{failure} failed, #{error} errors, #{pending} pending"
      end

      def after_everything
      end
    end
  end
end
