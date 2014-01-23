class ruby_build(
  $version     = '9cd77be141e066b968b4a7e72d0628c671e067e4',
  $source_root = '/opt/puppet_staging/sources',
  $prefix      = '/usr/local'
) {

  require 'git'

  # Pull down and install a tool to build our dev version of Ruby
  vcsrepo { 'ruby-build':
    ensure   => 'present',
    path     => "${source_root}/ruby-build",
    provider => 'git',
    source   => 'git://github.com/sstephenson/ruby-build.git',
    revision => $version,
    require  =>  Class['git'],
  }

  exec { 'install ruby-build':
    cwd         => "${source_root}/ruby-build",
    command     => "${source_root}/ruby-build/install.sh",
    environment => "PREFIX=${prefix}",
    creates     => "${prefix}/share/ruby-build",
    subscribe   => Vcsrepo['ruby-build'],
  }
}
