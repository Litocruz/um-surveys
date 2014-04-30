namespace :db do
  desc "Fill database with sample data"
  task create_admin: :environment do
  	admin = User.create!(name: "Example User",
                 email: "admin@dt.com",
                 password: "123qwe",
                 password_confirmation: "123qwe")
    admin.toggle!(:admin)
  end
end
