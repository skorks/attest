module Attest
  class OutputWriterConfigurator
    class << self
      def configure(output_writer_identifier)
        output_writer_identifier = output_writer_identifier || default_output_writer_identifier
        raise "You have specified an unknown output writer" unless output_writer_identifiers.include? output_writer_identifier
        output_writer_class = "#{output_writer_identifier.capitalize}OutputWriter"
        Attest.config.output_writer = Attest::Output.const_get(output_writer_class).new
      end

      def default_output_writer_identifier
        "basic"
      end

      def output_writer_identifiers
        [default_output_writer_identifier]
      end
    end
  end
end
