define ruby_build::install_ruby(
  $version      = $title,
  $ruby_prefix  = '/opt/rubies',
  $build_prefix = '/usr/local/bin'
) {

  # Install our version of Ruby
  exec { "install ruby ${version}":
    command => "${build_prefix}/ruby-build ${version} ${ruby_prefix}/${version}",
    creates => "${ruby_prefix}/${version}/bin/ruby",
    timeout => 600,
    require => Class['ruby_build'],
  }
}
