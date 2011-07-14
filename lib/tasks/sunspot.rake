namespace :sunspot do
  desc "indexes searchable models"
  task :index => :environment do
    [Position].each {|model| Sunspot.index!(model.all)} 
  end
end 

 