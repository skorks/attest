module Attest
  class TestLoader 
    class << self
      def execute
        switch_on_attest_mode
        Attest.config.possible_tests.each do |ruby_file|
          Attest.config.current_file = ruby_file 
          load ruby_file 
        end
        Attest.output_writer.summary
        switch_off_attest_mode
      end

      def switch_on_attest_mode
        ENV["attest"] = "true"
      end

      def switch_off_attest_mode
        ENV["attest"] = nil
      end
    end
  end
end
