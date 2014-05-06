class Survey < ActiveRecord::Base
	has_many  :questions, dependent: :destroy, order: "position ASC"
	belongs_to :user
  validates :name, :presence => true
  validates :code, :presence => true
  has_many :participants, dependent: :destroy
  accepts_nested_attributes_for :participants
	SCOPE = {
   :publica             => 0,
   :privada             => 1 
  }
  mount_uploader :banner, PictureUploader

  if Rails::VERSION::MAJOR == 3
    attr_accessible :name
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |survey|
        csv << survey.attributes.values_at(*column_names)
      end
    end
  end
end
