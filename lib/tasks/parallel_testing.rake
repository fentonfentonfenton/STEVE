# frozen_string_literal: true

require 'dotenv'
require 'require_all'

require_all "features/support/lib"

task :parallel_testing do
  include Testrail

  puts 'starting setup'
  Rake::Task['setup'].execute
  puts 'setup done'

  start_time = Time.now
  puts 'invoking cucumber tasks'
  Rake::Task['cucumber_tasks'].invoke
  puts 'all cucumber tasks done'
  puts "total run time: #{Time.now - start_time} seconds"
  puts 'starting teardown'
  if testrail_enabled && valid_testrail_project && scenarios_executed
    Rake::Task['teardown'].execute
  end
  puts 'teardown done'
end

task :setup do
  Dotenv.load
  ENV['PARALLEL_TESTING'] = 'true'
end

def all_cucumber_tasks
  tasks = nil
  Rake.application.in_namespace(:cucumber) do |namespace|
    tasks = namespace.tasks.map(&:name)
  end
  tasks
end

multitask cucumber_tasks: all_cucumber_tasks

task :teardown do
  Dotenv.load
  puts 'starting pushing all results to testrail'
  pushed_results = TestrailResults.new.collect.push
  puts 'done pushing all results to testrail'
  puts 'sending slack notification'
  Webhook.new(run_id: pushed_results.run_id).post
  puts 'done sending slack notification'
end
