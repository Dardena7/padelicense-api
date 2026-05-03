class UserPolicy < ApplicationPolicy
  def show?
    user&.id == record.id || user&.admin?
  end

  def update?
    user&.id == record.id || user&.admin?
  end

  def destroy?
    user&.admin?
  end
end
