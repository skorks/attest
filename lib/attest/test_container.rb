require 'attest'

module Attest
  class TestContainer

    attr_reader :description, :test_objects, :file
    attr_accessor :before, :after

    def initialize(description)
      @file = Attest.current_file
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
      Attest.output_writer.after_context
    end
  end
end
