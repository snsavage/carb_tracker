class FoodPolicy < ApplicationPolicy
  def show?
    record_belongs_to_user? || record.try(:from_api?)
  end

  def edit?
    record_belongs_to_user?
  end

  def update?
    edit?
  end

  def destroy?
    edit? && record_not_used_in_recipe?
  end

  class Scope < Scope
    def resolve
      Food.where(user_id: user.id).or(Food.from_api)
    end
  end

  private

  def record_not_used_in_recipe?
    !Ingredient.exists?(food_id: record.id)
  end
end
