class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.references :user
      t.timestamps
    end
    add_index :surveys, :user_id
  end
end
