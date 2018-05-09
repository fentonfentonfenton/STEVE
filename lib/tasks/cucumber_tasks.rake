# frozen_string_literal: true

namespace :cucumber do
  task :all_scenarios do
    system('bundle exec cucumber --tag @1 --format pretty -c')
  end

  task :l_scenarios do
    system('bundle exec cucumber --tag @2 --format pretty -c')
  end
end
