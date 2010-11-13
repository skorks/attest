module Attest
  module Output
    class BasicOutputWriter
      def initialize
        @containers = []
      end

      def before_everything
      end

      def before_context(container)
        @containers << container
        puts container.description
      end

      def before_test(test_object)
        print " - #{test_object.description}"
      end

      def after_test(test_object)
        test_status = nil
        test_object.results.each do |result|
          test_status = result.status if !result.success?
        end
        puts
      end

      def after_context
      end

      def after_everything
      end
    end
  end
end
