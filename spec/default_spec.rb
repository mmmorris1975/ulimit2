require 'spec_helper'

platforms = [
  { 'centos' => '5.9' },
  { 'centos' => '6.3' },
  { 'centos' => '6.4' },
  { 'centos' => '6.5' },
  { 'redhat' => '5.9' },
  { 'redhat' => '5.10' },
  { 'redhat' => '6.3' },
  { 'redhat' => '6.4' },
  { 'redhat' => '6.5' },
  { 'fedora' => '18' },
  { 'fedora' => '19' },
  { 'fedora' => '20' },
  { 'ubuntu' => '12.04' },
  { 'ubuntu' => '13.04' },
  { 'debian' => '7.2' },
  { 'debian' => '7.4' }
]

platforms.each { |i| i.each_pair do |p,v|
  describe 'ulimit2::default' do
    let (:chef_run) { ChefSpec::Runner.new(platform:p, version:v, :log_level => :info) do |node|
      Chef::Log.debug(sprintf("#### FILE: %s  PLATFORM: %s  VERSION: %s ####", ::File.basename(__FILE__), p, v))

      env = Chef::Environment.new
      env.name 'testing'
      # Stub the node to return this environment
      node.stub(:chef_environment).and_return env.name

      node.set['ulimit']['params']['default']['nofile'] = 9999
      node.set['ulimit']['params']['default']['nproc']['soft'] = 1234
      node.set['ulimit']['params']['default']['nproc']['hard'] = 1235
      node.set['ulimit']['params']['root']['nproc']['soft'] = 'unlimited'
      node.set['ulimit']['params']['@group']['nofile']['hard'] = 54321

      # Stub any calls to Environment.load to return this environment
      Chef::Environment.stub(:load).and_return env

      Chef::Config[:solo] = true
    end.converge described_recipe}

    it 'creates the config file with approprate contents' do
      file = '/etc/security/limits.d/999-chef-ulimit.conf'

      expect(chef_run).to create_template(file)
        .with(
          owner: 'root',
          group: 'root',
          mode:  '0644'
        )

      expect(chef_run).to render_file(file)
      expect(chef_run).to render_file(file).with_content(/\*\s+-\s+nofile\s+9999/)
      expect(chef_run).to render_file(file).with_content(/\*\s+soft\s+nproc\s+1234/)
      expect(chef_run).to render_file(file).with_content(/\*\s+hard\s+nproc\s+1235/)
      expect(chef_run).to render_file(file).with_content(/root\s+soft\s+nproc\s+unlimited/)
      expect(chef_run).to render_file(file).with_content(/@group\s+hard\s+nofile\s+54321/)
    end
  end
end }
