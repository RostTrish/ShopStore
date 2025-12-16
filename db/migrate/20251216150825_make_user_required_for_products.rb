class MakeUserRequiredForProducts < ActiveRecord::Migration[8.1]
  def change
    change_column_null :products, :user_id, false
  end
end
