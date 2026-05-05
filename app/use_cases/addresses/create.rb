module Addresses
  class Create < BaseUseCase
    def initialize(user:, attributes:)
      @user = user
      @attributes = attributes
    end

    private

    def call
      @user.addresses.create!(@attributes)
    end
  end
end
