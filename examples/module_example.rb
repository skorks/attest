class StandardCalculator
  def self.plus(x, y)
    x + y
  end

  def self.minus(x, y)
    x - y
  end
end

module CalcModule
  def double(x)
    2 * x
  end
end

if ENV["attest"]
  this_tests "another class with calculations" do
    test("adding two numbers") {should_be_true{StandardCalculator.plus(5,11) == 16}}
    test("subtracting two numbers"){should_not_be_true{StandardCalculator.minus(10,5) == 4}}
  end

  this_tests CalcModule do
    before_all do 
      @hello = [1,2,3]
    end

    before_each { @module_class = create_and_include(CalcModule) }

    test("magically instance of a class that will include the module"){should_be_true{@module_class.double(5)==10}}

    nosetup
    test("another test without setup"){should_be_true{true}}

    disabled
    test("a disabled test"){should_be_true{true}}

    test("accessing object which was created in a before_all block") do 
      should_be_true{@hello.size == 3}
      @hello << 5
      should_be_true{@hello.size == 4}
    end

    test("accessing object from before_all block again to make sure it is the same object") do 
      should_be_true{@hello.last == 5}
      @hello << 10
    end
  end
end
