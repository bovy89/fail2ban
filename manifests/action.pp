# Define: fail2ban::action
#
#
# Parameters:
#
# [*action_ensure*]
#   String. Install or remove this action
#   Default: present
#
# [*actionname*]
#   String. The name of the action
#   Default: $title
#
# [*actionstart*]
#   Array. command(s) executed when the jail starts.
#   Default: []
#
# [*actionstop*]
#   Array. command(s) executed when the jail stops
#   Default: []
#
# [*actioncheck*]
#   Array. the command ran before any other action
#   Default: []
#
# [*actionban*]
#   Array. command(s) that bans the IP address after maxretry log lines matches within last findtime seconds.
#   Default: []
#
# [*actionunban*]
#   Array. command(s) that unbans the IP address after bantime.
#   Default: []
#
# [*actioninitvars*]
#   Array. Variables for the INIT stanza of the action file.
#   Default: []
#
# [*actionbefore*]
#   String. indicates an action file that is read before the [Definition] section.
#   Default: undef
#
# [*actionafter*]
#   String. indicates an action file that is read after the [Definition] section.
#   Default: undef
#
# [*actiontemplate*]
#   String. Template to use when defining a new action
#   Default: fail2ban/action.local.erb
#
define fail2ban::action (
  $action_ensure  = 'present',
  $actionname     = $title,
  $actionstart    = [],
  $actionstop     = [],
  $actioncheck    = [],
  $actionban      = [],
  $actionunban    = [],
  $actioninitvars = [],
  $actionbefore   = undef,
  $actionafter    = undef,
  $actiontemplate = 'fail2ban/action.local.erb',
) {

  if ! defined(Class['fail2ban']) {
      fail('You must include the fail2ban base class before define an action')
  }

  validate_array($actionstart, $actionstop, $actioncheck, $actionban, $actionunban, $actioninitvars)
  validate_re($action_ensure, '^(present|absent)$', "${action_ensure} is not supported for action_ensure.")

  $action_file = "${fail2ban::config_dir}/action.d/${actionname}.local"


  file { "${actionname}.local":
    ensure  => $action_ensure,
    path    => $action_file,
    mode    => $fail2ban::config_file_mode,
    owner   => $fail2ban::config_file_owner,
    group   => $fail2ban::config_file_group,
    content => template($actiontemplate),
    require => Package[$fail2ban::package_name],
    notify  => $fail2ban::manage_service_autorestart,
  }

}
