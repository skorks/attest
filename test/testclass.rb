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

    test("error with message successful test"){should_raise(RuntimeError){@test_class.runtime_error}.with_message(/An error/)}

    test("add two to an integer") { should_be_true{ @test_class.add_two(3) == 5 } }

    test("add two with incorrect result in test") { should_be_true{ @test_class.add_two(5) == 8 } } 

    test("multiply two integers") {should_be_true{ @test_class.multiply(2,3) == 6 }}
    
    test("truth expectation should be fulfilled"){should_be_true{@test_class.good}}
  end
end
