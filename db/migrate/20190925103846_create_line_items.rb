class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.date :date
      t.float :amount
      t.string :title
      t.string :source
      t.string :month_year
      t.integer :category_id

      t.timestamps
    end
  end
end
