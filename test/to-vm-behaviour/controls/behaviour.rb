# BEHAVIOUR, observed FROM an external client (TO the VM).
# The `http` resource runs on the RUNNER, not the target, so the request
# crosses the network exactly as a real client's would. This is the rung that
# catches loopback-only binds and firewall rules that a localhost probe on the
# VM passes right through.

VM_URL = 'http://172.28.0.11/'.freeze

control 'index-reachable-over-network-is-neutral' do
  impact 1.0
  title 'the neutral index page is reachable from an external client'
  desc 'An HTTP request from off-box must return the neutral page and name no web server.'

  describe http(VM_URL, open_timeout: 5, read_timeout: 5) do
    its('status') { should cmp 200 }
    its('body') { should match(/It works\./) }
    its('body') { should_not match(/nginx/i) }
  end
end
