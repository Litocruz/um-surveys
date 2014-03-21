class AddScopeToSurveys < ActiveRecord::Migration
  def change
  	add_column :surveys, :scope, :integer, default: 0
  end
end
