require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test

RuboCop::RakeTask.new

desc 'generate README.md'
task :readme do
  puts 'generate README.md'
  files = %w(
    overview.md
    index.md
    requirements.md
    installation.md
    configuration.md
    usage.md
    contributing.md
    license.md
  )
  File.open('README.md', 'w') do |f|
    files.each do |ff|
      input_file = File.read("./etc/#{ff}")
      f.puts(input_file)
      f.puts("\n")
    end
  end
end
