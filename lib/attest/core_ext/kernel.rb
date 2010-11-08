module Kernel
  def new_method_missing(name, *args, &block)
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
      old_method_missing(name, *args, &block) 
    end
  end
  alias_method :old_method_missing, :method_missing
  alias_method :method_missing, :new_method_missing

  private
  def this_tests(subject, &block)
    test_context = Attest::TestContext.new(subject, block)
    test_context.execute
  end


end
