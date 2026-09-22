# BEHAVIOUR, observed FROM the VM.
# The request runs on the target (over SSH) against localhost, so it tests
# what the RUNNING server actually returns -- not merely what was declared.
# The body must be the neutral page and must not name a web server.

control 'index-served-locally-is-neutral' do
  impact 1.0
  title 'nginx serves the neutral index page on the VM itself'
  desc 'An HTTP request from the VM to localhost must return the neutral page and name no web server.'

  describe command('wget -qO- http://localhost/') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/It works\./) }
    its('stdout') { should_not match(/nginx/i) }
  end
end
