class Object
  def itself 
    Attest::Itself.new(self)
  end

  def method_missing(name, *args, &block)
    private_method = false
    private_methods.each do |meth|
     if meth == name
       private_method = true
     end
    end
    if private_method
      send(name, *args, &block)
    else
      super
    end
    #if it has a private method with the name given then attemp to call that
    #if it has an instance variable with the name then create a reader for it and return in via the reader
  end
end
