require 'unit_helper'

describe 'ruby_build', :type => :class do
  it { should contain_exec('install ruby-build') }
end
