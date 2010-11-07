puts "abc123"
puts Dir.pwd
puts ENV["BUNDLE_GEMFILE"]
require "rubygems"
require "bundler"
Bundler.setup(:default)
puts "abc123"
Bundler.require

module Attest

end

puts "HELLO"
