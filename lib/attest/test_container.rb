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
      Attest.output_writer.before_container(self)
      container_context = Attest::ExecutionContext.new
      begin
        container_context.instance_eval(&@before) if @before
        @test_objects.each do |test_object|
          test_object.run container_context
        end
        container_context.instance_eval(&@after) if @after
      rescue => e
        Attest.output_writer.an_error(e)
        Attest.output_writer.ignore_container(self)
      end
      Attest.output_writer.after_container(self)
    end
  end
end
