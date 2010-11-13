module Attest
  class TestContainer

    attr_reader :description

    def initialize(description)
      @description = description
      @test_objects = []
    end

    def add(test)
      @test_objects << test
    end

    def execute_all
      Attest.output_writer.before_context(self)
      @test_objects.each do |test_object|
        test_object.run
      end
    end
  end
end
