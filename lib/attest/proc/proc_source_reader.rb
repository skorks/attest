require 'stringio'
require 'irb/ruby-lex'

module Attest
  class ProcSourceReader
    def initialize(file, line)
      @file = file
      @start_line = line
    end

    def self.find(file, line)
      source_reader = ProcSourceReader.new(file, line)
      source_reader.read_source

    end

    def read_source
      lines_starting_with_proc = read_lines_from_file
      return nil if lines_starting_with_proc.nil?
      lexer = RubyLex.new
      lexer.set_input(StringIO.new(lines_starting_with_proc.join))
      start_token, end_token = nil, nil
      nesting = 0
      while token = lexer.token
        if RubyToken::TkDO === token || RubyToken::TkfLBRACE === token
          nesting += 1
          start_token = token if nesting == 1
        elsif RubyToken::TkEND === token || RubyToken::TkRBRACE === token
          if nesting == 1
            end_token = token 
            break
          end
          nesting -= 1
        end
      end
      proc_lines = lines_starting_with_proc[start_token.line_no - 1 .. end_token.line_no - 1]
      proc_lines
    end

    def read_lines_from_file
      raise "No file for proc where does it come from" unless @file 
      begin
        File.readlines(@file)[(@start_line - 1) .. -1]
      rescue
        nil
      end
    end
  end
end
