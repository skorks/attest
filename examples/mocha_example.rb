class Product 
end

if ENV["attest"]
  this_tests "testing of basic mocha integration" do
    test("mocking a class method") do 
      product = Product.new
      Product.expects(:find).with(1).returns(product)
      should_be_true {product == Product.find(1)}
    end

    test("mocking an instance method") do 
      product = Product.new
      product.expects(:save).returns(true)
      should_be_true{product.save}
    end

    test("stubbing an instance method") do 
      prices = [stub(:pence => 1000), stub(:pence => 2000)]
      product = Product.new
      product.stubs(:prices).returns(prices)
      should_be_true{  [1000, 2000] ==  product.prices.collect {|p| p.pence}}
    end

    test("stubbing an all instances") do 
      Product.any_instance.stubs(:name).returns('stubbed_name')
      product = Product.new
      should_be_true{ 'stubbed_name' == product.name }
    end

    test("traditional mocking") do
      object = mock()
      object.expects(:expected_method).with(:p1, :p2).returns(:result)
      should_be_true { :result == object.expected_method(:p1, :p2) }
    end

    test("shortcuts") do 
      object = stub(:method1 => :result1, :method2 => :result2)
      should_be_true{ :result1 == object.method1 }
      should_be_true{ :result2 == object.method2 }
    end
  end
end
