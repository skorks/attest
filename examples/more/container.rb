require File.expand_path(File.dirname(__FILE__) + "/../magic_calculator")
require File.expand_path(File.dirname(__FILE__) + "/../standard_calculator")

if ENV["attest"]
  this_tests "test from required files should not be executed when this file is loaded" do
    test("it just passes"){should_be_true{true}}
  end
end
