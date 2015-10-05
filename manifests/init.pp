class ruby_build(
  $version     = '9cd77be141e066b968b4a7e72d0628c671e067e4',
  $source_root = '/opt/puppet_staging/sources',
  $prefix      = '/usr/local',
  $dev_packages = $ruby_build::params::dev_packages,
) inherits ruby_build::params {

  if ( $::osfamily == 'Darwin' ) {
    $git_manage = false
  } else {
    $git_manage = true
  }
  class { 'git': package_manage => $git_manage, }
  contain 'git'
  ensure_packages($dev_packages)

  # Pull down and install a tool to build our dev version of Ruby
  vcsrepo { 'ruby-build':
    ensure   => 'present',
    path     => "${source_root}/ruby-build",
    provider => 'git',
    source   => 'git://github.com/sstephenson/ruby-build.git',
    revision => $version,
    require  =>  Class['git'],
  }

  file { [ "${prefix}/share/ruby-build", "${prefix}/bin/ruby-build" ]:
    ensure => absent,
    force  => true,
    before => Exec['install ruby-build'],
  }

  exec { 'install ruby-build':
    cwd         => "${source_root}/ruby-build",
    command     => "${source_root}/ruby-build/install.sh",
    environment => "PREFIX=${prefix}",
    creates     => "${prefix}/share/ruby-build",
    subscribe   => Vcsrepo['ruby-build'],
  }
}
