require 'attest'
require 'attest/core_ext/kernel'

module Attest
  class TestLoader 
    class << self
      def execute(possible_tests, output_writer)
        switch_on_attest_mode
        output_writer.before_all_tests
        possible_tests.each do |ruby_file|
          Attest.config.current_file = ruby_file
          load ruby_file 
        end
        output_writer.after_all_tests
        output_writer.summary
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
