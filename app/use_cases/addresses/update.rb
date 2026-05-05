module Addresses
  class Update < BaseUseCase
    def initialize(address:, attributes:)
      @address = address
      @attributes = attributes
    end

    private

    def call
      @address.update!(@attributes)
      @address
    end
  end
end
