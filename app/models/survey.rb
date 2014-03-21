class Survey < ActiveRecord::Base
	has_many  :questions
	belongs_to :user
  validates :name, :presence => true
  has_many :participants, dependent: :destroy
  accepts_nested_attributes_for :participants
	SCOPE = {
   :publica             => 0,
   :privada             => 1 
  }


  if Rails::VERSION::MAJOR == 3
    attr_accessible :name
  end
end
