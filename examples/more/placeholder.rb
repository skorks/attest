class Placeholder1
  def divide(x,y)
    x/y
  end
end

class Placeholder2
  def multiply(x,y)
    x*y
  end
end

def random_method(x)
  x+x
end

if ENV["attest"]
  this_tests Placeholder1 do
    test("divide successful"){should_be_true{Placeholder1.new.divide(16, 4) == 4}}
    test("divide by zero"){should_raise{Placeholder1.new.divide(5,0)}}
  end
  this_tests Placeholder2 do
    test("multiply") {should_be_true{Placeholder2.new.multiply(2,3)==6}}
  end
  this_tests "random methods" do
    test("random method"){should_be_true{random_method("abc") == "abcabc"}}
  end
end
