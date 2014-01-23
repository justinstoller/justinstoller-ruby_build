require 'system_helper'

describe 'When using ruby-build' do

  before(:all) do
    RUBIES  = '/tmp/ruby_testing'
    SOURCES = '/tmp/sources'
    RBUILD  = '/tmp/ruby-build'
    RUBY    = "#{RUBIES}/2.1.0/bin/ruby"

    apply_manifest( <<-PP_EOS )
      class prereqs {
        package { 'openssl-devel': ensure => installed }

        file { [ '#{RUBIES}', '#{SOURCES}', '#{RBUILD}' ]:
          ensure => directory,
        }

        class { 'ruby_build':
          source_root => '#{SOURCES}',
          prefix      => '#{RBUILD}',
        }
      }

      include prereqs
      ruby_build::install_ruby { '2.1.0':
        ruby_prefix  => '#{RUBIES}',
        build_prefix => '#{RBUILD}/bin',
        require      => Class['prereqs']
      }

    PP_EOS
  end

  it 'can be in a custom directory' do
    expect( default.file_exist?( RBUILD + '/bin/ruby-build' )).to eq( true )
  end

  describe 'a working Ruby 2.1.0 install' do

    it 'can be in a custom directory' do
      expect( default.file_exist?( RUBY )).to eq( true )
    end

    it 'can run basic Ruby' do
      cmd = %{-e 'print "blah"'}

      shell "#{RUBY} #{cmd}" do |result|
        expect( result.stdout ).to eq("blah")
      end
    end

    it 'is actually Ruby 2.1.0' do
      shell "#{RUBY} -e 'print RUBY_VERSION'" do |result|
        expect( result.stdout ).to eq('2.1.0')
      end
    end

    it 'can use SSL' do
      cmd = "-ropenssl -e 'print OpenSSL::Random.random_bytes(16).length'"
      shell "#{RUBY} #{cmd}" do |result|
        expect( result.stdout ).to eq('16')
      end
    end

    it 'can load YAML' do
      cmd = %{-ryaml -e 'print ["one", 2].to_yaml'}

      shell "#{RUBY} #{cmd}" do |result|
        expect( result.stdout ).to eq("---\n- one\n- 2\n")
      end
    end

    it 'can install and load gems' do
      shell "#{RUBIES}/2.1.0/bin/gem install rake --no-ri --no-rdoc --force"
      shell "#{RUBY} -rrake -e 'print Rake'" do |result|
        expect( result.stdout ).to eq( 'Rake' )
      end
    end
  end
end
