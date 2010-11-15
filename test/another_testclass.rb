class AnotherClass
  def self.plus(x, y)
    x + y
  end

  def self.minus(x, y)
  end
end

if ENV["attest"]
  this_tests "Another class with claculations" do
    test("adding two numbers") {should_be_true{AnotherClass.plus(5,11) == 16}}
    test("subtracting two numbers"){should_be_true{AnotherClass.minus(10,5) == 4}}
  end
end
