require "rubygems"
require "bundler"
Bundler.setup(:default)

#require "trollop"
require "singleton"
require 'attest/config'
require 'attest/core_ext/kernel'
require 'attest/core_ext/object'

require 'attest/expectation_result'
require 'attest/test_container'
require 'attest/test_object'
require 'attest/execution_context'
require 'attest/test_loader'
require 'attest/test_parser'
require 'attest/itself'
require 'attest/attest_error'

require 'attest/output/basic_output_writer'

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
