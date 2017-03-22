class LogPolicy < ApplicationPolicy
  def show?
    record_belongs_to_user?
  end

  def today?
    show?
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  class Scope < Scope
    def resolve
      Log.where(user_id: user.id)
    end
  end
end
