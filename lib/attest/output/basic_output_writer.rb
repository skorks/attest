require 'attest/output/output_writer'
require 'attest/expectation_result'

module Attest
  module Output
    class BasicOutputWriter < Attest::Output::OutputWriter
      def before_container(container)
        previous_container = @containers.last
        @containers << container
        puts "#{container.file}:" unless previous_container && previous_container.file == container.file
        puts " #{ container.description }"
      end

      def after_container(container)
        puts 
      end

      def before_test(test_object)
        print "  - #{test_object.description}"
      end

      def after_test(test_object)
        relevant_result = determine_relevant_result test_object
        print " [#{relevant_result.status.upcase}]" if relevant_result
        if relevant_result && relevant_result.failure?
          2.times { puts } 
          puts "     #{relevant_result.source_location}"
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
    end
  end
end
