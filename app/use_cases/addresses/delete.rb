module Addresses
  class Delete < BaseUseCase
    def initialize(address:)
      @address = address
    end

    private

    def call
      @address.destroy!
      @address
    end
  end
end
