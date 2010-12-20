require 'attest/interface/test_double_configurator'

this_tests "test double configuration" do 
  test("should use default when nil test double identifier") do 
    actual_test_double_identifier = TestDoubleConfigurator.configure(nil)
    should_equal(TestDoubleConfigurator.default_test_double_identifier, actual_test_double_identifier)
  end

  test("should raise an error when non-existant test double identifier") do 
    should_raise{TestDoubleConfigurator.configure("non-existant")}
  end

  test("should call configuration method when real test double identifer used") do 
    TestDoubleConfigurator.test_double_identifiers.each do |double_identifer|
      configure_method_name = :"configure_#{double_identifer}"
      TestDoubleConfigurator.expects(configure_method_name)
      TestDoubleConfigurator.configure(double_identifer)
    end
  end
end
