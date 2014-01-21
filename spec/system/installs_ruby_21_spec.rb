require 'system_helper'

describe 'installing ruby 2.1' do
  MANIFEST = <<-PP_EOS
    file { '/tmp/sources': ensure => directory }
    class { 'ruby_build': source_root => '/tmp/sources' }

    ruby_build::install_ruby { '2.1.0': }

  PP_EOS
  it 'does stuff' do
    apply_manifest MANIFEST
  end
end
