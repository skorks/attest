module Attest
  module Output
    module OutputWriterInterface
      def before_all_tests
      end
      def after_all_tests
      end
      def before_container(container)
      end
      def after_container(container)
      end
      def before_test(test_object)
      end
      def after_test(test_object)
      end
      def summary
      end
      def ignore_container(container)
      end
      def an_error(error_object)
      end
    end
  end
end
