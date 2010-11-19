class AnotherClass
  def self.plus(x, y)
    x + y
  end

  def self.minus(x, y)
  end
end

module CalcMethods
  def double(x)
    2 * x
  end
end

if ENV["attest"]
  this_tests "Another class with claculations" do
    test("adding two numbers") {should_be_true{AnotherClass.plus(5,11) == 16}}
    test("subtracting two numbers"){should_be_true{AnotherClass.minus(10,5) == 4}}
  end

  this_tests CalcMethods do
    before_all do
      @module_class = create_and_include(CalcMethods)
    end

    test("doubling on class that inlcludes module"){should_be_true{@module_class.double(5)==10}}
  end
end
