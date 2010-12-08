require "rubygems"
require "bundler/setup"

current_dir = File.expand_path(File.dirname(__FILE__))

require "singleton"

require "#{current_dir}/attest/interface/test_double_configurator"
require "#{current_dir}/attest/interface/output_writer_configurator"
require "#{current_dir}/attest/interface/possible_tests_configurator"

require "#{current_dir}/attest/config"
require "#{current_dir}/attest/core_ext/kernel"
require "#{current_dir}/attest/core_ext/object"
require "#{current_dir}/attest/core_ext/proc"

require "#{current_dir}/attest/expectation_result"
require "#{current_dir}/attest/test_container"
require "#{current_dir}/attest/test_object"
require "#{current_dir}/attest/execution_context"
require "#{current_dir}/attest/test_loader"
require "#{current_dir}/attest/test_parser"
require "#{current_dir}/attest/attest_error"
require "#{current_dir}/attest/output/basic_output_writer"
require "#{current_dir}/attest/output/failuresonly_output_writer"
require "#{current_dir}/attest/output/testunit_output_writer"

module Attest
  class << self
    def configure
      config = Attest::Config.instance
      block_given? ? yield(config) : config
    end

    alias :config :configure

    Attest::Config.public_instance_methods(false).each do |name|
      self.class_eval <<-EOT
        def #{name}(*args)
          configure.send("#{name}", *args)
        end
      EOT
    end
  end
end
