control 'nginx-package' do
  impact 1.0
  title 'nginx is installed'
  desc 'The nginx package must be present on the VM.'

  describe package('nginx') do
    it { should be_installed }
  end
end

control 'nginx-service' do
  impact 1.0
  title 'nginx is running and enabled'
  desc 'The nginx service must be running and start on boot.'

  describe service('nginx') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

control 'nginx-port' do
  impact 1.0
  title 'nginx is listening on port 80'
  desc 'The VM must accept HTTP connections on the default port.'

  describe port(80) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end
end
