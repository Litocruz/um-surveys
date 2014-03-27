class ParticipantMailer < ActionMailer::Base
  default from: "julian.lamadrid@um.edu.ar"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.participant_mailer.survey_sent.subject
  #
  def survey_sent(participant)
    @participant = participant
    mail :to => participant.email, :subject => "Conteste la encuesta"
  end
end
