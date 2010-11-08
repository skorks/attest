class TestClass
  def set_var(var)
    @var = var
  end

  def add_two(var)
    var + 2
  end

  private
  def multiply(x, y)
    x * y
  end
end

def some_method(x)
  x.reverse
end

if ENV["attest"]
  this_tests TestClass do 
    before_all do 
      @test_class = TestClass.new
    end

    after_all do
      @test_class = nil
    end

    test "set_var" do
      @test_class.set_var(6) 
      @test_class.var.itself.should != nil
    end

    test("add_two") {
      @test_class.add_two(3).itself.should == 5
    }
    test("add_two 2") { @test_class.add_two(5).itself.should == 8 } 
    test( "multiply works" ) {@test_class.multiply(2,3).itself.should == 6}
  end
end
