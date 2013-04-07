desc "This task is called by the Heroku scheduler add-on"
task :index_sphinx => :environment do
  puts "Indexing Sphinx db..."
  flying-sphinx index
  puts "done."
end
