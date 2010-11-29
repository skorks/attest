class StandardCalculator
  def self.plus(x, y)
    x + y
  end

  def self.minus(x, y)
    x - y
  end
end

module CalcMethods
  def double(x)
    2 * x
  end
end

if ENV["attest"]
  this_tests "another class with claculations" do
    test("adding two numbers") {should_be_true{StandardCalculator.plus(5,11) == 16}}
    test("subtracting two numbers"){should_not_be_true{StandardCalculator.minus(10,5) == 4}}
  end

  this_tests CalcMethods do
    before_all { @module_class = create_and_include(CalcMethods) }

    test("magically instance of a class that will include the module"){should_be_true{@module_class.double(5)==10}}
  end
end
