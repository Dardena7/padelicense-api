class CartPolicy < ApplicationPolicy
  def show?
    user&.id == record.user_id || user&.admin?
  end

  def update?
    user&.id == record.user_id || user&.admin?
  end
end
