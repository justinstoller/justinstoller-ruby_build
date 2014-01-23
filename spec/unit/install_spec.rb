require 'unit_helper'

describe 'ruby_build::install_ruby', :type => :define do
  let(:version) { '2.0.0-p1234' }
  let(:title)   {  version      }

  it { should contain_exec("install ruby #{version}") }
end
