class ruby_build(
  $version     = 'v20130923',
  $source_root = '/opt/puppet_staging/sources'
) {

  # Pull down and install a tool to build our dev version of Ruby
  vcsrepo { 'ruby-build':
    path     => "${sources_root}/ruby-build",
    ensure   => 'present',
    provider => 'git',
    source   => 'git://github.com/sstephenson/ruby-build.git',
    revision => $version,
    require  =>  Class['git'],
  }

  exec { 'install ruby-build':
    cwd         => "${sources_root}/ruby-build",
    command     => "${sources_root}/ruby-build/install.sh",
    creates     => '/usr/local/share/ruby-build',
    subscribe   => Vcsrepo['ruby-build'],
  }
}
