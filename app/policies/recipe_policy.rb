class RecipePolicy < ApplicationPolicy
  def show?
    record_belongs_to_user? || record.public?
  end

  def edit?
    record_belongs_to_user?
  end

  def update?
    edit?
  end

  def destroy?
    edit? && record_not_used_in_entry?
  end

  class Scope < Scope
    def resolve
      Recipe.where(user_id: user.id).or(Recipe.where(public: true))
    end
  end

  private

  def record_not_used_in_entry?
    !Entry.exists?(recipe_id: record.id)
  end
end
