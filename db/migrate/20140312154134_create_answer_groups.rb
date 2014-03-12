class CreateAnswerGroups < ActiveRecord::Migration
  def change
    create_table :answer_groups do |t|
			t.references :survey
      t.references :user, polymorphic: true

      t.timestamps
    end
    add_index :answer_groups, :survey_id
    add_index :answer_groups, [:user_id, :user_type]
  end
end
