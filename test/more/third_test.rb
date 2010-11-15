class ThirdTest
  def divide(x, y)
    x/y
  end
end

class FourthClass
  def multiply(x,y)
    x*y
  end
end

if ENV["attest"]
  this_tests ThirdTest do
    test("divide successful"){should_be_true{ThirdTest.new.divide(16, 4) == 4}}
    test("divide by zero"){should_raise{ThirdTest.new.divide(5,0)}}
  end
  this_tests FourthClass do
    test("multiply") {should_be_true{FourthClass.new.multiply(2,3)==6}}
  end
end
