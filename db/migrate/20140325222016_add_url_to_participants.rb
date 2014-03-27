class AddUrlToParticipants < ActiveRecord::Migration
  def change
  	add_column :participants, :url_token, :string
  end
end
