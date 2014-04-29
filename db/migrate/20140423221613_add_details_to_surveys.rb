class AddDetailsToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :start_date, :datetime
    add_column :surveys, :end_date, :datetime
    add_column :surveys, :code, :string
    add_column :surveys, :status, :boolean, default: false
    add_column :surveys, :banner, :string
  end
end
