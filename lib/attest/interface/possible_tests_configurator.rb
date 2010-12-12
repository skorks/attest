module Attest
  class PossibleTestsConfigurator
    class << self
      def configure(included_locations, excluded_locations = nil)
        raise "Need to know location for tests" if included_locations.compact.size == 0
        possible_test_files = included_test_files included_locations
        files_to_ignore = excluded_test_files excluded_locations
        puts possible_test_files - files_to_ignore
        possible_test_files - files_to_ignore
      end

      def included_test_files(included_locations)
        file_list_from_list_of included_locations
      end

      def excluded_test_files(excluded_locations)
        return [] if excluded_locations.nil?
        file_list_from_list_of excluded_locations
      end

      def file_list_from_list_of(locations)
        file_list = []
        locations.compact.each do |location|
          expanded_location = File.expand_path(location)
          file_list << file_list_from_single(expanded_location)
        end
        file_list.flatten
      end

      def file_list_from_single(location)
        return location if File.file? location
        Dir[File.join(File.expand_path(location), "**/*.rb")].collect { |ruby_file| ruby_file }
      end
    end
  end
end
