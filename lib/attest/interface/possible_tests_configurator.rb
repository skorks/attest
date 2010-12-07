module Attest
  class PossibleTestsConfigurator
    class << self
      def configure(included_locations, excluded_locations = nil)
        raise "Excluding locations fot tests is not yet implemented" if excluded_locations
        raise "Need to know location for tests" if included_locations.compact.size == 0
        possible_tests = []
        included_locations.compact.each do |location|
          expanded_location = File.expand_path(location)
          possible_tests << derive_possible_tests_from_expanded_location(expanded_location)
        end
        possible_tests.flatten
      end

      def derive_possible_tests_from_expanded_location(location)
        return location if File.file? location
        Dir[File.join(File.expand_path(location), "**/*.rb")].collect { |ruby_file| ruby_file }
      end
    end
  end
end
