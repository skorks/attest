class TestClass
  def set_var(var)
    @var = var
  end

  def add_two(var)
    var + 2
  end

  def errors
    raise "An error"
  end

  def good
    true
  end

  def runtime_error
    raise RuntimeError, "An error, a runtime one"
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
  This.will_test TestClass do
    before_all do 
      @test_class = TestClass.new
    end

    after_all do
      @test_class = nil
    end

    test("multiple expectations in one test") do
      @test_class.set_var(6)
      should_be_true{@test_class.var == 6}
      should_raise(RuntimeError){@test_class.runtime_error}.with_message(/1An error/)
    end

    test("deliberately fail the test"){should_fail}

    test("doesn't raise error") {should_not_raise{@test_class.good}}

    test("expecting that it raises an error") do
      should_raise do
        @test_class.errors
      end
    end 

    test("unexpected error test"){@test_class.errors}

    #test ("error with message"){should_raise(RuntimeError){@test_class.runtime_error}.with_message(/An error/)}

    #test "set_var" do
      #@test_class.set_var(6) 
      #@test_class.var.itself.should_not_equal nil
    #end

    #test("add_two") { @test_class.add_two(3).itself.should_equal 5 }

    #test("add_two 2") { @test_class.add_two(5).itself.should_equal 8 } 

    #test("multiply works") {@test_class.multiply(2,3).itself.should_equal 6}
    
    #test("errors test"){@test_class.errors}

    #test("for truth"){should_be_true{@test_class.good}}
  end
end
