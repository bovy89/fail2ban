# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#

include fail2ban

class { 'fail2ban':
    jails_config => 'concat',
    mailto       => 'admin@example.com',
    ignoreip     => ['127.0.0.1/8', '192.168.6.0/24'],
    bantime      => '86400',
    findtime     => '1800',
    maxretry     => '3',
    log_target   => '/var/log/fail2ban.log',
}

fail2ban::jail { 'sshd':
    action => '%(action_)s',
}

class { 'fail2ban':
  service_ensure => 'stopped',
  disableboot    => true,
}

class { 'fail2ban':
  fail2ban_ensure => 'absent',
}

fail2ban::action { 'sendmail-common':
    actionstart => [' '],
    actionstop  => [' '],
}
