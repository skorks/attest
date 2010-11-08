class TestClass
  def set_var(var)
    @var = var
  end

  def add_two(var)
    var + 2
  end
end

if ENV["attest"]
  this_tests TestClass do 
    before_all do 
      test_class = TestClass.new
    end

    after_all do
      puts "cleaning up"
    end

    test "set_var" do
      test_class.set_var(6) 
      failure if test_class.var == nil
    end

    test "add_two" do
      failure if test_class.add_two(3) != 5
    end
  end
end

#run it like attest test/*
#Testing TestClass
# - set_var 
# - set_var sets value to 5
#SUCCESSES: 2
#FAILURES: 0
#ERRORS: 0
