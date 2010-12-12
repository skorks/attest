$:.unshift(File.expand_path(File.dirname(__FILE__))) unless $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'attest/config'

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
