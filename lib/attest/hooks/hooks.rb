module Attest
  module Hooks
    module ClassMethods
      private
      def do_before_method(*method_names, &block)
        method_names.each do |method_name| 
          redefine_original_method method_name
          before_method_name = "__before_#{method_name}__"
          self.class_eval <<-EOT
            def #{before_method_name}(*args, &block)
              yield
            end
          EOT
          #define_method before_method_name do |*args|
            #block.call(self, :method => method_name, :args => args)
          #end
          private before_method_name
        end
      end

      def do_after_method(*method_names, &block)
        method_names.each do |method_name| 
          redefine_original_method method_name
          after_method_name = "__after_#{method_name}__"
          define_method after_method_name do |*args|
            block.call(self, :method => method_name, :args => args)
          end
          private after_method_name
        end
      end

      def redefine_original_method(method_name)
        original_method_name = "__original_#{method_name}__"
        before_method_name = "__before_#{method_name}__"
        after_method_name = "__after_#{method_name}__"
        relevant_methods = private_instance_methods
        unless relevant_methods.include?(original_method_name.to_sym)
          alias_method original_method_name, method_name
          private original_method_name
          define_method method_name do |*args|
            __send__ before_method_name, *args if private_methods.include?(before_method_name.to_sym)
            return_value = __send__ original_method_name, *args
            __send__ after_method_name, *args if private_methods.include?(after_method_name.to_sym)
            return_value
          end
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
