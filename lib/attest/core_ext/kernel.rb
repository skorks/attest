module Kernel
  private
  def this_tests(subject, &block)
    test_context = Attest::TestContext.new(subject, block)
    test_context.execute
  end

  def method_missing(name, *args, &block)
    #puts name.to_sym
    #private_methods.each do |meth|
      #if meth.name == name.to_sym
        #puts "hello"
      #end
    #end
    #if private_method_defined? name.to_sym
      #puts "DEFINED"
    #end
    #if it has a private method with the name given then attemp to call that
    #if it has an instance variable with the name then create a reader for it and return in via the reader
    super
  end
end
