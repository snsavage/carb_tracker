class CreateStats < ActiveRecord::Migration
  def change
    create_view :stats
  end
end
