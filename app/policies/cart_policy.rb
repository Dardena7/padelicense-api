class CartPolicy < ApplicationPolicy
  def show?
    return true if record.guest?
    user&.id == record.user_id || user&.admin?
  end

  def update?
    show?
  end
end
