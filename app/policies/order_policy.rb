class OrderPolicy < ApplicationPolicy
  def show?
    user&.id == record.user_id || user&.admin?
  end
end
