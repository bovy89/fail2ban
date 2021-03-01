require 'spec_helper'

describe 'fail2ban::jail', type: :define do
  let(:title) { 'myjail' }
  let(:pre_condition) do
    "class {'::fail2ban':
      default_ignoreip       => ['192.168.6.123'],
      default_bantime        => '200',
      default_findtime       => '600',
      default_maxretry       => '100',
      backend                => 'mybackend',
      mailto                 => 'admin@example.com',
      banaction              => 'mybanaction',
      mta                    => 'mymta',
      default_jails_protocol => 'myprotocol',
      jails_chain            => 'mychain',
    }"
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'action with all default' do
        let(:expected) do
          "[DEFAULT]
ignoreip = 192.168.6.123
bantime  = 200
findtime = 600
maxretry = 100
backend = mybackend
destemail = admin@example.com
banaction = mybanaction
mta = mymta
protocol = myprotocol
chain = mychain

### Default action ###
## The simplest action to take: ban only
action_ = %(banaction)s[name=%(__name__)s, port=\"%(port)s\", protocol=\"%(protocol)s\", chain=\"%(chain)s\"]

## ban & send an e-mail with whois report and relevant log lines
## to the destemail.
action_mwl = %(banaction)s[name=%(__name__)s, port=\"%(port)s\", protocol=\"%(protocol)s\", chain=\"%(chain)s\"]
             %(mta)s-whois-lines[name=%(__name__)s, dest=\"%(destemail)s\", logpath=%(logpath)s, chain=\"%(chain)s\"]

# Choose default action.  To change, just override value of 'action' with the
# interpolation to the chosen action shortcut (e.g.  action_mw, action_mwl, etc) in jail.local
# globally (section [DEFAULT]) or per specific section
action = %(action_mwl)s
"
        end

        it { is_expected.to contain_concat__fragment('fail2ban_jails_header').with_target('/etc/fail2ban/jail.local').with_content(expected) }
        it { is_expected.to contain_concat__fragment('fail2ban_jails_footer').with_target('/etc/fail2ban/jail.local') }
        it { is_expected.to contain_concat__fragment("fail2ban_jail_#{title}").with_target('/etc/fail2ban/jail.local') }
      end

      describe 'action with all parameters' do
        let(:params) do
          {
            status: 'enable',
            ignoreip: ['127.0.0.1'],
            port: ['22'],
            jails_protocol: 'tcp',
            action: ['myaction'],
            logpath: ['/var/log/secure'],
            maxretry: '1',
            bantime: '2000',
            findtime: '5',
          }
        end
        let(:expected) do
          "##################
[myjail]
enabled  = true
filter   = myjail
ignoreip = 127.0.0.1
port     = 22
protocol = tcp
action   = myaction
logpath  = /var/log/secure
maxretry = 1
bantime  = 2000
findtime = 5

"
        end

        it { is_expected.to contain_concat__fragment('fail2ban_jails_header').with_target('/etc/fail2ban/jail.local') }
        it { is_expected.to contain_concat__fragment('fail2ban_jails_footer').with_target('/etc/fail2ban/jail.local') }
        it { is_expected.to contain_concat__fragment("fail2ban_jail_#{title}").with_target('/etc/fail2ban/jail.local').with_content(expected) }
      end
    end
  end
end
