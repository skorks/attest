require 'attest/test_parser'

module Kernel
  def new_method_missing(name, *args, &block)
    original_error = nil
    begin
        old_method_missing(name, *args, &block) 
      return
    rescue NoMethodError => e
      original_error = e
    end
    private_method = false
    instance_variable = false
    private_methods.each do |meth|
      private_method = true if meth == name
    end
    instance_variable = true if instance_variable_defined?("@#{name}".to_sym)
    if private_method
      send(name, *args, &block)
    elsif instance_variable
      self.class.class_eval do
        attr_reader name.to_sym
      end
      send(name, *args, &block)
    else
      raise original_error
    end
  end
  alias_method :old_method_missing, :method_missing
  alias_method :method_missing, :new_method_missing

  def new_require(filename)
    current_attest_value = ENV["attest"]
    ENV["attest"] = nil
    old_require(filename)
    ENV["attest"] = current_attest_value
  end
  alias_method :old_require, :require
  alias_method :require, :new_require

  private
  def this_tests(description="anonymous", &block)
    container = Attest::TestParser.new(description, block).parse
    container.execute_all
  end
  def current_method
    caller[0][/`([^']*)'/, 1]
  end
  def calling_method
    caller[1][/`([^']*)'/, 1]
  end
end
