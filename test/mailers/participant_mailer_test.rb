require 'test_helper'

class ParticipantMailerTest < ActionMailer::TestCase
  test "survey_sent" do
    mail = ParticipantMailer.survey_sent
    assert_equal "Survey sent", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
