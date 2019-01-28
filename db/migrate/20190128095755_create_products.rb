class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :part_number
      t.string :branch_id
      t.float :part_price
      t.text :short_description

      t.timestamps
    end
  end
end
