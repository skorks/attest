module Attest
  class ExpectationResult
    attr_reader :attributes
    def initialize(attributes={})
      @outcome = nil
      @attributes = attributes
    end

    [:success, :failure, :error].each do |status|
      eval <<-EOT
        def #{status}
          @outcome = current_method
        end
        def #{status}?
          current_method.chop == @outcome
        end
      EOT
    end

    def status
      @outcome
    end

    def update(attributes={})
      @attributes.merge!(attributes)
    end
  end
end
