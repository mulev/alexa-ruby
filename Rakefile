require 'rake/testtask'

ENV['env'] = 'test'
ENV['CODECLIMATE_REPO_TOKEN'] = '700b2d6bc97a4c5d504565407b412451e3d8fe2cf7967f57ca75c01ae7d92c16'

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
end
