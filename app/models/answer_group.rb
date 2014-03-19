class AnswerGroup < ActiveRecord::Base
	belongs_to :survey
    belongs_to :user, polymorphic: true
    has_many   :answers, inverse_of: :answer_group, autosave: true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :survey, :user
    end

    def AnswerGroup.new_vote_token
	    #SecureRandom.urlsafe_base64
	  end

	  def AnswerGroup.hash(token)
	    Digest::SHA1.hexdigest(token.to_s)
	  end

  	def AnswerGroup.create_vote_token(token)
    	vote_token = AnswerGroup.hash(token)
  	end
end
