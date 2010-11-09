module Attest
  class TestContainer
    def initialize(description)
      @description = description
      @test_objects = []
    end

    def add(test)
      @test_objects << test
    end

    def execute_all
      puts description
      @test_objects.each do |test_object|
        test_object.run
      end
    end
  end
end
