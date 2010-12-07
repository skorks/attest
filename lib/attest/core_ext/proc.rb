current_dir = File.expand_path(File.dirname(__FILE__))
require "#{current_dir}/../proc/proc_source_reader"

class Proc
  def to_string
    @source ||= Attest::ProcSourceReader.find(*source_descriptor)
  end

  private
  def source_descriptor
    unless @file && @line
      if md = /^#<Proc:0x[0-9A-Fa-f]+@(.+):(\d+)(.+?)?>$/.match(inspect)
        @file, @line = md.captures
      end
    end
    [@file, @line.to_i]
  end
end

if __FILE__ == $0
  simple_proc = Proc.new() { |a|
    puts  "Hello Rudy2" 
  }
  puts simple_proc.to_string

  another_simple_proc = Proc.new() do |x|
    #printing
    puts "Printing #{x}"
    puts "printing more stuff"
  end
  puts another_simple_proc.to_string

  third_proc = eval "Proc.new do puts 'blah'; end"
  puts third_proc.to_string
end
