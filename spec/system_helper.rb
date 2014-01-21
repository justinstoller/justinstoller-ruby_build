require 'beaker-rspec/beaker_shim'
include BeakerRSpec::BeakerShim

ROOT       = File.expand_path(File.join(__FILE__, '..', '..'))
support    = File.join(ROOT, 'spec', 'support')
modname    = File.basename(ROOT).split('-', 2).pop
hosts      = ENV['SYSTEM_HOSTS'] || 'default'
hosts_file = File.join(support, 'hosts', hosts + '.yml')

destroy   = ENV['SPEC_DESTROY'] == 'true'   ? ''                                 : '--preserve-hosts'
provis    = ENV['SPEC_PROVISION'] == 'true' ? ''                                 : '--no-provision'
keyfile   = ENV['SPEC_KEYFILE']             ? ['--keyfile', ENV['SPEC_KEYFILE']] : ['--keyfile', File.join(support, 'insecure_private_key')]
debug     = ENV['SPEC_DEBUG']               ? ['--log-level', 'debug']           : []




#Beaker::Utils::Validator.validate(@hosts, @options[:logger])


RSpec.configure do |c|

  if STDOUT.tty?
    # Enable color
    c.tty = true
  end

  # Define persistant hosts setting
  c.add_setting :hosts, :default => []
  # Define persistant options setting
  c.add_setting :options, :default => {}

  # Configure all nodes in nodeset
  c.before :suite do
    # gather our opts
    args = [destroy, provis, '--hosts', hosts_file, keyfile, debug].flatten
    options_parser = Beaker::Options::Parser.new
    @options = options_parser.parse_args(args)
    @options[:debug] = true
    logger = Beaker::Logger.new(options)
    @options[:logger] = logger

    # creat the netman
    @network_manager = Beaker::NetworkManager.new(@options, @options[:logger])

    # set test variables
    c.options = @options
    c.hosts   = @network_manager.provision

    # prepare our env for the test suite
    c.hosts.each do |host|
      on host, 'yum install -y git'

      mod_on_host = "#{host['distmoduledir']}/#{modname}"

      on( host, 'gem install rake bundler --no-ri --no-rdoc' )
      on( host, "mkdir -p #{mod_on_host}" )
      %w{manifests templates files Puppetfile tasks Rakefile Gemfile}.each do |to_trans|

        local_file = File.join(ROOT, to_trans)

        if File.exists?( local_file )
          scp_to( host, local_file, "#{mod_on_host}/#{to_trans}")
        end
      end

      on( host,
          "cd #{mod_on_host}; " +
          "LIBRARIAN_PUPPET_PATH=#{host['distmoduledir']} " +
          "BUNDLE_WITHOUT='ci lint spec pkg' rake deps:ruby; " +
          "rake deps:puppet")
    end
  end

  #Destroy nodes if no preserve hosts
  #c.after :suite do
  #  @network_manager.cleanup
  #end
end
