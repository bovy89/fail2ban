# Define: fail2ban::filter
#
#
# Parameters:
#
# [*filter_ensure*]
#   String. Install or remove this filter
#   Default: 'present'
#
# [*filtername*]
#   String. The name of the filter
#   Default: $title
#
# [*filterfailregex*]
#   String. command(s) executed when the jail failregexs.
#   Default: []
#
# [*filterignoreregex*]
#   String. command(s) executed when the jail ignoreregexs.
#   Default: []
#
# [*filterdefinitionvars*]
#   String. Variables for the INIT stanza of the filter file
#   Default: []
#
# [*filterbefore*]
#   String. indicates an filter file that is read before the [Definition] section.
#   Default: undef
#
# [*filterafter*]
#   String. indicates an filter file that is read after the [Definition] section.
#   Default: undef
#
# [*filtertemplate*]
#   String. Template to use when defining a new filter
#   Default: fail2ban/filter.local.erb
#
define fail2ban::filter (
  $filter_ensure        = 'present',
  $filtername           = $title,
  $filterfailregex      = [],
  $filterignoreregex    = [],
  $filterdefinitionvars = [],
  $filterbefore         = undef,
  $filterafter          = undef,
  $filtertemplate       = 'fail2ban/filter.local.erb',
) {

  if ! defined(Class['fail2ban']) {
      fail('You must include the fail2ban base class before define a filter')
  }

  validate_array($filterfailregex, $filterignoreregex, $filterdefinitionvars)
  validate_re($filter_ensure, '^(present|absent)$', "${filter_ensure} is not supported for filter_ensure.")

  $filter_file = "${fail2ban::config_dir}/filter.d/${filtername}.local"

  file { "${filtername}.local":
    ensure  => $filter_ensure,
    path    => $filter_file,
    mode    => $fail2ban::config_file_mode,
    owner   => $fail2ban::config_file_owner,
    group   => $fail2ban::config_file_group,
    content => template($filtertemplate),
    require => Package[$fail2ban::package_name],
    notify  => $fail2ban::manage_service_autorestart,
  }

}
