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
  File.open('./etc/help.md', 'w') do |f|
    f.puts('## Help')
    f.puts("\n")
    f.puts('```')
    f.puts(`bl help`)
    f.puts('```')
    f.puts("\n")
    str = <<-EOS
View global or command specific help:

```
bl help
bl help list
bl help search
bl help add
```
EOS
    f.puts(str)
  end
  files = %w(
    overview.md
    index.md
    requirements.md
    installation.md
    configuration.md
    help.md
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

desc 'system test'
task :system_test do
  ret = true
  commands = [
    'category list',
    'config',
    'file list',
    'gitrepo list',
    'group list',
    'help',
    'milestone list',
    'priorities',
    'project list',
    'resolutions',
    'roles',
    'space disk-usage',
    'space get-notification',
    'space info',
    'statuses',
    'type colors',
    'type list',
    'user list',
    'user myself',
    'webhook list',
    'wiki list'
  ]
  commands.each do |c|
    command = 'bl ' + c + ' > /dev/null'
    system(command)
    if $?.exited?
      puts "#{command}: OK"
    else
      puts "#{comamnd}: NG"
    end
  end
end
