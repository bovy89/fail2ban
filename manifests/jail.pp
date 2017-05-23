# Define: fail2ban::jail
#
#
# Parameters:
#
# [*jail_ensure*]
#   String. Install or remove this jail
#   Default: 'present'
#
# [*jailname*]
#   String. The name of the jail
#   Default: $title
#
# [*order*]
#   String. Order in jail config file
#   Default: 50
#
# [*status*]
#   String. Enalbe or disable this jail
#   Default: undef
#
# [*filter*]
#   String. Name of the filter to be used by the jail to detect matches. Each single match by a filter increments the counter within the jail
#   Default: $title
#
# [*ignoreip*]
#   Array. IP addresses ignored by fail2ban
#   Default: []
#
# [*port*]
#   Array. Port to filter
#   Default: []
#
# [*jails_protocol*]
#   String. This is the type of traffic that will be dropped when an IP ban is implemented. This is also the type of traffic that is sent to the new iptables chain.
#   Default: undef
#
# [*action*]
#   Array. This sets the action that will be used when the threshold is reached.
#   Default: []
#
# [*logpath*]
#   Array. Path to the log file which is provided to the filter
#   Default: []
#
# [*maxretry*]
#   String. Number of matches (i.e. value of the counter) which triggers ban action on the IP.
#   Default: undef
#
# [*bantime*]
#   String. Duration (in seconds) for IP to be banned for. Negative number for "permanent" ban.
#   Default: undef
#
# [*findtime*]
#   String. The counter is set to zero if no match is found within "findtime" seconds.
#   Default: undef
#
define fail2ban::jail (
  $jail_ensure    = 'present',
  $jailname       = $title,
  $order          = '50',
  $status         = undef,
  $filter         = $title,
  $ignoreip       = [],
  $port           = [],
  $jails_protocol = undef,
  $action         = [],
  $logpath        = [],
  $maxretry       = undef,
  $bantime        = undef,
  $findtime       = undef,
) {

  if ! defined(Class['fail2ban']) {
      fail('You must include the fail2ban base class before define a jail')
  }

  validate_array($ignoreip, $port, $action, $logpath)

  $real_status = $status ? {
    '/(?i:disabled)/' => false,
    default           => true,
  }

  if ! defined(Concat[$fail2ban::jails_file]) {
    concat { $fail2ban::jails_file:
      ensure  => $jail_ensure,
      mode    => $fail2ban::jails_file_mode,
      warn    => true,
      owner   => $fail2ban::jails_file_owner,
      group   => $fail2ban::jails_file_group,
      notify  => $fail2ban::manage_service_autorestart,
      require => Package[$fail2ban::package_name],
    }

    concat::fragment{ 'fail2ban_jails_header':
      target  => $fail2ban::jails_file,
      content => template($fail2ban::jails_template_header),
      order   => '01',
      notify  => $fail2ban::manage_service_autorestart,
    }

    concat::fragment{ 'fail2ban_jails_footer':
      target  => $fail2ban::jails_file,
      content => template($fail2ban::jails_template_footer),
      order   => '99',
      notify  => $fail2ban::manage_service_autorestart,
    }
  }

  concat::fragment{ "fail2ban_jail_${title}":
    target  => $fail2ban::jails_file,
    content => template('fail2ban/concat/jail.local-stanza.erb'),
    order   => $order,
    notify  => $fail2ban::manage_service_autorestart,
  }
}
