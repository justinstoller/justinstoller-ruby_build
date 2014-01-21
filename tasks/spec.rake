
desc 'Run all tests'
task :spec => %w{spec:unit}

namespace :spec do
  desc 'Run rspec-puppet'
  task :unit do
    rspec = 'bundle exec rspec '
    pattern_opts = '-P "spec/unit/**/*_spec.rb" '
    format_opts  = ENV['SPEC_FORMAT'] || '--color'
    Dir.chdir ROOT do
      system( rspec + pattern_opts + format_opts )
    end
  end

  desc 'Run beaker-rspec'
  task :system do
    rspec = 'bundle exec rspec '
    pattern_opts = '-P "spec/system/installs_ruby_21_spec.rb" '
    format_opts  = ENV['SPEC_FORMAT'] || '--color'
    Dir.chdir ROOT do
      system( rspec + pattern_opts + format_opts )
    end
  end
end
