require File.expand_path(File.dirname(__FILE__) + "/../examples/basic_functionality_example")
require File.expand_path(File.dirname(__FILE__) + "/../examples/module_example")

if ENV["attest"]
  this_tests "test from required files should not be executed when this file is loaded" do
    test("it just passes"){should_be_true{true}}
  end
end

#TODO need to figure out a way to make this a proper test
