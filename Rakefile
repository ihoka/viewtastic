require 'rake'
require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "be9-viewtastic"
    gem.summary = "Presenter implementation for Ruby on Rails 3.x"
    gem.email = "olegdashevskii@gmail.com"
    gem.homepage = "http://github.com/be9/viewtastic"
    gem.authors = ["Istvan Hoka", "Oleg Dashevskii"]

    gem.files = FileList['lib/**/*.rb', 'LICENSE', 'History.txt']
    gem.test_files = []
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
