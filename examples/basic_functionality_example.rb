class ACalculator 
  def remember_value(value)
    @value_in_memory = value
  end

  def increment(value)
    value + 1
  end

  def divide(numerator, denominator)
    numerator/denominator
  end

  def add(value1, value2)
    value1 + value2
  end

  private
  def multiply(x, y)
    x * y
  end
end

if ENV["attest"]
  this_tests ACalculator do
    before_each{@calculator = ACalculator.new}
    after_each{@calculator = nil}

    test("a pending test")
    test("deliberately fail the test"){should_fail}
    test("a successful empty test"){}
    test("should NOT raise an error") {should_not_raise{@calculator.increment 4}}
    test("it should raise an error, don't care what kind") {should_raise {@calculator.divide 5, 0}}
    test("it should raise a ZeroDivisionError error with a message"){should_raise(ZeroDivisionError, :with_message => /divided by.*/){@calculator.divide 5, 0}}
    test("adding 5 and 2 does not equal 8") { should_not_be_true{ @calculator.add(5,2) == 8 } } 
    test("this test will be an error when non-existant method called") {should_be_true{ @calculator.non_existant }}
    test("should be able to call a private method like it was public"){should_be_true{@calculator.multiply(2,2) == 4}}

    test "access an instance variable without explicitly exposing it" do
      @calculator.remember_value(5)
      should_be_true {@calculator.value_in_memory == 5}
    end

    test("multiple expectations in one test") do
      should_not_raise{@calculator.increment 4}
      should_raise{ @calculator.non_existant }
    end

    nosetup 
    test("should not have access to calculator instance since run without setup"){should_be_true{@calculator == nil}}
  end
end
