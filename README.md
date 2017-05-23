# fail2ban

[![Build Status](https://travis-ci.org/bovy89/fail2ban.svg?branch=master)](https://travis-ci.org/bovy89/fail2ban)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Usage - Configuration options and additional functionality](#usage)

## Module Description

This module manages fail2ban on RedHat systems.


## Usage

### Basic usage:
```puppet
class { '::fail2ban':
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
```

### Disable fail2ban service.
```puppet
class { '::fail2ban':
  service_ensure => 'stopped',
  disableboot    => true,
}
```

### Remove fail2ban package
```puppet
class { '::fail2ban':
  fail2ban_ensure => 'absent',
}
```

### Disable email notification
```puppet
fail2ban::action {'sendmail-common':
    actionstart => [' '],
    actionstop  => [' '],
}
```
