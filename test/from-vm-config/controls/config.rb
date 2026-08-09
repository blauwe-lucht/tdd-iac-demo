# CONFIGURATION, observed FROM the VM.
# These resources execute on the target over SSH. They inspect declared state
# only -- they never exercise the running server. Everything here passes as
# long as the playbook wrote what it was told to write.

control 'nginx-installed' do
  impact 1.0
  title 'nginx package is installed'
  describe package('nginx') do
    it { should be_installed }
  end
end

control 'nginx-service-enabled' do
  impact 1.0
  title 'nginx service is enabled and running'
  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'index-page-present-and-neutral' do
  impact 1.0
  title 'the index page on disk is the neutral page and names no web server'
  desc <<~DESC
    Pure configuration: the declared index file is on disk and its bytes do
    not name a web server. This says nothing about what the RUNNING server
    actually returns to a client.
  DESC

  describe file('/var/www/html/index.html') do
    it { should exist }
    its('content') { should match(/It works\./) }
    its('content') { should_not match(/nginx/i) }
  end
end
