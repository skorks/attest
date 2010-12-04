module Attest
  class Config
    include Singleton

    attr_accessor :output_writer, :current_file, :testdouble

    def initialize
      @output_writer = Attest::Output::BasicOutputWriter.new
    end

  end
end
