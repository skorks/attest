module Attest
  class ExpectationResult
    include Comparable
    class << self
      def status_types
        status_weights.keys
        #[:success, :failure, :error, :pending]
      end

      def status_weights
        {:success => 1, :failure => 2, :error => 3, :pending => 4}
      end
    end

    attr_reader :attributes
    attr_accessor :source_location
    def initialize(attributes={})
      @outcome = nil
      @attributes = attributes
    end

    Attest::ExpectationResult.status_types.each do |status|
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

    def status_weight
      Attest::ExpectationResult.status_weights[status.to_sym]
    end

    def <=>(another_result)
      return 1 unless another_result
      self.status_weight <=> another_result.status_weight
    end
  end
end
