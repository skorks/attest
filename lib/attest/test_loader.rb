module Attest
  class TestLoader 
    class << self
      def load_tests_from(file, directory)
        raise "Need to know location of tests" unless file || directory
        load_tests_from_single_file(file)
        load_all_test_found_in_directory(directory)
      end

      def load_tests_from_single_file(file)
        if file
          Attest.config.current_file = File.join(File.expand_path(file))
          load file
        end
      end

      def load_all_test_found_in_directory(directory)
        if directory
          Dir[File.join(File.expand_path(directory), "**/*.rb")].each do |ruby_file|
            Attest.config.current_file = ruby_file 
            load ruby_file 
          end
        end
      end
    end
  end
end
