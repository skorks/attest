require 'singleton'

module Attest
  class Config
    include Singleton

    attr_accessor :output_writer, :current_file, :testdouble, :possible_tests
  end
end
