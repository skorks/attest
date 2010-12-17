require 'attest/interface/output_writer_configurator'

this_tests "output writer configuration" do 
    test("should use the default when output writer identifier is nil") do 
      should_be_true{ OutputWriterConfigurator.configure(nil).class == OutputWriterConfigurator.configure(OutputWriterConfigurator.default_output_writer_identifier).class}
    end

  test("should raise an error when output writer identifier doesn't match any of the known ones") do
    should_raise {OutputWriterConfigurator.configure("unknown identifier")}
  end

  test("should not raise an error when output writer identifier is one of the known ones") do 
    identifiers = OutputWriterConfigurator.output_writer_identifiers
    identifiers.each do |identifier|
      should_not_raise{OutputWriterConfigurator.configure(identifier)}
    end
  end
end
