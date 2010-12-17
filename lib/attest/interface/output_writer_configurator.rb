require 'attest/output/basic_output_writer'
require 'attest/output/test_unit_output_writer'
require 'attest/output/failures_only_output_writer'

module Attest
  class OutputWriterConfigurator
    class << self
      def configure(output_writer_identifier)
        output_writer_identifier = output_writer_identifier || default_output_writer_identifier
        raise "You have specified an unknown output writer" unless output_writer_identifiers.include? output_writer_identifier
        output_writer_class = "#{output_writer_identifier}OutputWriter"
        #Attest.config.output_writer = Attest::Output.const_get(output_writer_class).new
        Attest::Output.const_get(output_writer_class).new
      end

      def default_output_writer_identifier
        "Basic"
      end

      def output_writer_identifiers
        [default_output_writer_identifier, "TestUnit", "FailuresOnly"]
      end
    end
  end
end
