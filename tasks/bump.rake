desc 'shortcut for bump:patch'
task bump: 'bump:patch'

namespace :bump do
  desc 'Bump x.y.Z'
  task :patch
  
  desc 'Bump x.Y.z'
  task :minor
  
  desc 'Bump X.y.z'
  task :major
end

# extracted and modified from https://github.com/grosser/project_template
rule /^bump:.*/ do |t|
  sh "git status | grep 'nothing to commit'" # ensure we are not dirty
  index = ['major', 'minor','patch'].index(t.name.split(':').last)
  file = 'lib/philotic/version.rb'

  version_file = File.read(file)
  old_version, *version_parts = version_file.match(/(\d+)\.(\d+)\.(\d+)/).to_a
  version_parts[index] = version_parts[index].to_i + 1
  version_parts[2] = 0 if index < 2
  version_parts[1] = 0 if index < 1
  new_version = version_parts * '.'
  File.open(file,'w'){|f| f.write(version_file.sub(old_version, new_version)) }

  sh "bundle && git add #{file} && git commit -m 'bump version to #{new_version}'"
end
