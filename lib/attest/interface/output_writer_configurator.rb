module Attest
  class OutputWriterConfigurator
    class << self
      def configure(output_writer_identifier)
        output_writer_identifier = output_writer_identifier || default_output_writer_identifier
        raise "You have specified an unknown output writer" unless output_writer_identifiers.include? output_writer_identifier
        output_writer_class = "#{output_writer_identifier.capitalize}OutputWriter"
        #Attest.config.output_writer = Attest::Output.const_get(output_writer_class).new
        Attest::Output.const_get(output_writer_class).new
      end

      def default_output_writer_identifier
        "basic"
      end

      def output_writer_identifiers
        [default_output_writer_identifier, "testunit", "failuresonly"]
      end
    end
  end
end

if ENV["attest"]
  this_tests "output writer configuration" do 
    test("should use the default when output writer identifier is nil") do 
      should_be_true{ OutputWriterConfigurator.configure(nil).class == OutputWriterConfigurator.configure(OutputWriterConfigurator.default_output_writer_identifier).class}
    end

    test("should raise an error when output writer identifier doesn't match any of the known ones") do
      should_raise {OutputWriterConfigurator.configure("unknown identifier")}
    end

    test("should not raise an error when output writer identifier is one of the known ones") do 
      identifiers = OutputWriterConfigurator.output_writer_identifiers
      random_identifier = identifiers[rand(identifiers.size)]
      should_not_raise{OutputWriterConfigurator.configure(random_identifier)}
    end
  end
end
