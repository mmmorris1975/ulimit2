require 'spec_helper'

describe file '/etc/security/limits.d/999-chef-ulimit.conf' do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should_not be_writable.by('others') }

  its(:content) { should match(/^\*\s+-\s+nofile\s+10240$/) }
  its(:content) { should match(/^\*\s+soft\s+nproc\s+2048$/) }
  its(:content) { should match(/^root\s+soft\s+nofile\s+15360$/) }
  its(:content) { should match(/^root\s+hard\s+nofile\s+unlimited$/) }
  its(:content) { should match(/^@sysadmin\s+hard\s+nproc\s+4096$/) }
end
