class ruby_build(
  $version     = 'v20131122.1',
  $source_root = '/opt/puppet_staging/sources'
) {

  require 'git'

  # Pull down and install a tool to build our dev version of Ruby
  vcsrepo { 'ruby-build':
    path     => "${source_root}/ruby-build",
    ensure   => 'present',
    provider => 'git',
    source   => 'git://github.com/sstephenson/ruby-build.git',
    revision => $version,
    require  =>  Class['git'],
  }

  exec { 'install ruby-build':
    cwd         => "${source_root}/ruby-build",
    command     => "${source_root}/ruby-build/install.sh",
    creates     => '/usr/local/share/ruby-build',
    subscribe   => Vcsrepo['ruby-build'],
  }
}
