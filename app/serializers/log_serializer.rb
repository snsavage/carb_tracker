class LogSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :log_date,
             :per_recipe_stats,
             :total_stats,
             :next,
             :prev

  def next
    @object.next(@instance_options[:user])
  end

  def prev
    @object.prev(@instance_options[:user])
  end
end
