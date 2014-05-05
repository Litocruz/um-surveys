class Survey < ActiveRecord::Base
	has_many  :questions, dependent: :destroy, conditions: {position: "ASC"}
	belongs_to :user
  validates :name, :presence => true
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

  def upload(upload)
    name = upload['banner'].original_filename
    directory = "public/data"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(upload['banner'].read) }
  end
end
