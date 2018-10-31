require 'beaker-rspec'

UNSUPPORTED_PLATFORMS = '%w[Windows Solaris AIX]'.freeze

unless ENV['RS_PROVISION'] == 'no' || ENV['BEAKER_provision'] == 'no'
  # This will install the latest available package on el and deb based
  # systems fail on windows and osx, and install via gem on other *nixes
  foss_opts = { default_action: 'gem_install' }

  default.is_pe? ? install_pe : install_puppet(foss_opts)

  hosts.each do |host|
    on hosts, "mkdir -p #{host['distmoduledir']}"
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      # Install this module
      copy_module_to(host, source: proj_root, module_name: '')
      # List other dependencies here so they are installed on the host
      on host, puppet(
        'module',
        'install',
        'puppetlabs-stdlib',
      ), acceptable_exit_codes: [0, 1]
    end
  end
end
