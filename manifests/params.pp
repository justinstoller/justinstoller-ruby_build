#
class ruby_build::params {
  case $::osfamily {
    'RedHat': {
      $dev_packages = [ 'ruby-devel',
              'libxml2-devel', 'libxslt-devel',
              'openssl-devel', 'readline-devel',
              'gcc', 'gcc-c++', 'bzip2' ]
    }
    'Debian': {
      $dev_packages = [ 'ruby-dev',
              'libxml2-dev', 'libxslt1-dev',
              'libreadline-dev',
              'libssl-dev', 'zlib1g-dev',
              'gcc', 'g++', 'make', 'bzip2' ]
    }
    default: {
      $dev_packages = [ ]
    }
  }
}
