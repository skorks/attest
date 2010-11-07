class TestClass
  def set_var(var)
    @var = var
  end
end

if ENV["attest"]
  tests_for TestClass do 
    before_all do 
      test_class = TestClass.new
    end

    test set_var do
      test_class.set_var(6) 
      failure if test_class.var == nil
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
