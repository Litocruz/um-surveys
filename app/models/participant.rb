class Participant < ActiveRecord::Base
	belongs_to :survey  
  before_create { generate_token(:url_token) }
	require 'csv'
 
  def self.import(file)
  	participants = []
    CSV.foreach(file.path, headers: true) do |row|
		  participant_hash = row.to_hash # exclude the price field
		  participants << participant_hash
		  Rails.logger.debug "Person attributes hash: #{participant_hash.inspect}"
=begin      
      participant = Participant.where(id: participant_hash["id"])
 			
      if participant.count == 1
        participant.first.update_attributes(participant_hash)
        #participant.first.update_attributes(participant_hash.except("id"))
      else
      	@survey = Survey.find(params[:survey_id])
      	participant_hash["survey_id"] = @survey.id
        Participant.create!(participant_hash)
      end # end if !participant.nil?
=end
    end # end CSV.foreach
    Rails.logger.debug "Person attributes hash: #{participants.inspect}"
    participants
  end # end self.import(file)

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Participant.exists?(column => self[column])
  end

  def send_survey_email
    generate_token(:url_token)
    save!
    ParticipantMailer.survey_sent(self).deliver
  end
end
