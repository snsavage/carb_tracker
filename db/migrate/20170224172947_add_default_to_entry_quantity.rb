class AddDefaultToEntryQuantity < ActiveRecord::Migration[5.0]
  def change
    change_column_default :entries, :quantity, from: nil, to: 1
  end
end
