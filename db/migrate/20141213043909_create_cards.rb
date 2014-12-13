class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :list, index: true
      t.string :content

      t.timestamps null: false
    end
    add_foreign_key :cards, :lists
  end
end
