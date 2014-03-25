class ParticipantsController < ApplicationController
	before_filter :find_survey!

  def index
    @participants = @survey.participants
  end
 
  def import
    begin
      participant_hash = Participant.import(params[:file])

			participant_hash.each{ |part|
				participant = Participant.where(email: part["email"], survey_id: @survey.id)
	      if participant.count == 1
	        Rails.logger.debug "ControllerP Encontro coincidencia parth: #{part.inspect}"
	        participant.first.update_attributes(part)
	        #participant.first.update_attributes(participant_hash.except("id"))
	      else
	      	Rails.logger.debug "ControllerP No Encontro coincidencia part: #{part.inspect}"
	        status = @survey.participants.create!(part)
	        Rails.logger.debug "ControllerP status: #{status.inspect}"
	      end # end if !participant.nil?
			}
      redirect_to survey_participants_url, notice: "Participantes actualizados."	
    rescue
      redirect_to survey_participants_url, notice: "Formato de archivo CSV invalido."
    end
  end


  private
    def find_survey!
      @survey = Survey.find(params[:survey_id])
    end
    def participant_params
     params.require(:participant).permit(:participant_hash).merge(:survey => @survey)
    end
end
