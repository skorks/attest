module Attest
  class AttestError < RuntimeError
    def initialize(message)
      super message
    end
  end
end
