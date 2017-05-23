# Class fail2ban
#
# This module manages fail2ban on RedHat systems.
#
# Parameters:
#
# [*package_name*]
#   String. Fail2ban package name
#   Default: 'fail2ban'
#
# [*service_name*]
#   String. Fail2ban service name
#   Default: 'fail2ban'
#
# [*config_dir*]
#   String. Configurations basedir
#   Default: /etc/fail2ban
#
# [*config_file*]
#   String. Main configuration file
#   Default: /etc/fail2ban/fail2ban.local
#
# [*config_file_mode*]
#   String. Main configuration file mode
#   Default: 0644
#
# [*config_file_owner*]
#   String. Main configuration file owner
#   Default: root
#
# [*config_file_group*]
#   String. Main configuration file group
#   Default: root
#
# [*config_file_template*]
#   String. Main configuration file template
#   Default: fail2ban/fail2ban.local.erb
#
# [*disableboot*]
#   Boolean. Disable fail2ban service at boot
#   Default: false
#
# [*service_autorestart*]
#   Boolean. Automatically restarts fail2ban service on configuration change
#   Default: true
#
# [*fail2ban_ensure*]
#   String. Install or remove fail2ban
#   Default: present
#
# [*service_ensure*]
#   String. Ensure fail2ban service running or stopped
#   Default: running
#
# [*source_dir*]
#   String. If defined, the whole fail2ban.configuration directory content is retrieved
#   recursively from the specified source
#   Default: undef
#
# [*source_dir_owner*]
#   String. Configuration directory owner
#   Default: root
#
# [*source_dir_group*]
#   String. Configuration directory group
#   Default: root
#
# [*source_dir_purge*]
#   Boolean. If set to true the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   Default: false
#
# [*jails_config*]
#   String. Define how to manage jails configuration (file or concat)
#   Default: undef
#
# [*jails_file*]
#   String. Jails configuration file
#   Default: /etc/fail2ban/jail.local
#
# [*jails_file_mode*]
#   String. Jails configuration file mode
#   Default: 0644
#
# [*jails_file_owner*]
#   String. Jails configuration file owner
#   Default: root
#
# [*jails_file_group*]
#   String. Jails configuration file group
#   Default: root
#
# [*jails_content*]
#   String. Jails configuration file content (only with jails_config => file)
#   Default: undef
#
# [*jails_template_header*]
#   String. Jail configuration file header (with jails_config != file)
#   Default: fail2ban/concat/jail.local-header.erb
#
# [*jails_template_footer*]
#   String. Jail configuration file footer (with jails_config != file)
#   Default: fail2ban/concat/jail.local-footer.erb
#
# [*default_ignoreip*]
#   Array. IP addresses ignored by fail2ban
#   Default: ['127.0.0.1/8']
#
# [*default_bantime*]
#   String. Duration (in seconds) for IP to be banned for. Negative number for "permanent" ban.
#   Default: 600
#
# [*default_findtime*]
#   String. The counter is set to zero if no match is found within "findtime" seconds.
#   Default: 600
#
# [*default_maxretry*]
#   String. Number of matches (i.e. value of the counter) which triggers ban action on the IP.
#   Default: 5
#
# [*backend*]
#   String. Specifies the backend used to get files modification.
#   Default: auto
#
# [*mailto*]
#   String. Notification email address
#   Default: "hostmaster@${::domain}"
#
# [*banaction*]
#   String. This sets the action that will be used when the threshold is reached.
#   Default: iptables-multiport
#
# [*mta*]
#   String. This is the mail transfer agent that will be used to send notification emails.
#   Default: sendmail
#
# [*default_jails_protocol*]
#   String.  This is the type of traffic that will be dropped when an IP ban is implemented. This is also the type of traffic that is sent to the new iptables chain.
#   Default: tcp
#
# [*jails_chain*]
#   String. This is the chain that will be configured with a jump rule to send traffic to the fail2ban funnel.
#   Default: INPUT
#
# [*use_epel*]
#   Boolean. fail2ban package 
#   Default: false
#
# [*log_level*]
#   String. Fail2ban log level (CRITICAL, ERROR, WARNING, NOTICE, INFO, DEBUG)
#   Default: undef
#
# [*log_target*]
#   String. Fail2ban log target ([ STDOUT | STDERR | SYSLOG | FILE ])
#   Default: undef
#
class fail2ban (
  $package_name           = $::fail2ban::params::package_name,
  $service_name           = $::fail2ban::params::service_name,
  $config_dir             = $::fail2ban::params::config_dir,
  $config_file            = $::fail2ban::params::config_file,
  $config_file_mode       = $::fail2ban::params::config_file_mode,
  $config_file_owner      = $::fail2ban::params::config_file_owner,
  $config_file_group      = $::fail2ban::params::config_file_group,
  $config_file_template   = $::fail2ban::params::config_file_template,
  $disableboot            = $::fail2ban::params::disableboot,
  $service_autorestart    = $::fail2ban::params::service_autorestart,
  $fail2ban_ensure        = $::fail2ban::params::fail2ban_ensure,
  $service_ensure         = $::fail2ban::params::service_ensure,
  $source_dir             = $::fail2ban::params::source_dir,
  $source_dir_owner       = $::fail2ban::params::source_dir_owner,
  $source_dir_group       = $::fail2ban::params::source_dir_group,
  $source_dir_purge       = $::fail2ban::params::source_dir_purge,
  $jails_config           = $::fail2ban::params::jails_config,
  $jails_file             = $::fail2ban::params::jails_file,
  $jails_file_mode        = $::fail2ban::params::jails_file_mode,
  $jails_file_owner       = $::fail2ban::params::jails_file_owner,
  $jails_file_group       = $::fail2ban::params::jails_file_group,
  $jails_content          = $::fail2ban::params::jails_content,
  $jails_template_header  = $::fail2ban::params::jails_template_header,
  $jails_template_footer  = $::fail2ban::params::jails_template_footer,
  $default_ignoreip       = $::fail2ban::params::default_ignoreip,
  $default_bantime        = $::fail2ban::params::default_bantime,
  $default_findtime       = $::fail2ban::params::default_findtime,
  $default_maxretry       = $::fail2ban::params::default_maxretry,
  $backend                = $::fail2ban::params::backend,
  $mailto                 = $::fail2ban::params::mailto,
  $banaction              = $::fail2ban::params::banaction,
  $mta                    = $::fail2ban::params::mta,
  $default_jails_protocol = $::fail2ban::params::default_jails_protocol,
  $jails_chain            = $::fail2ban::params::jails_chain,
  $use_epel               = $::fail2ban::params::use_epel,
  $log_level              = $::fail2ban::params::log_level,
  $log_target             = $::fail2ban::params::log_target,
) inherits fail2ban::params {


  validate_bool($disableboot, $service_autorestart, $source_dir_purge, $use_epel)
  validate_re($fail2ban_ensure, '^(present|absent)$', "${fail2ban_ensure} is not supported for fail2ban_ensure.")
  validate_re($service_ensure, '^(running|stopped)$', "${service_ensure} is not supported for service_ensure.")
  validate_array($default_ignoreip)

  if $fail2ban_ensure == 'absent' {
    $manage_file = 'absent'
  }else{
    $manage_file = 'present'
  }

  if $disableboot {
    $manage_service_enable = false
  }else{
    $manage_service_enable = true
  }

  if $service_autorestart {
    $manage_service_autorestart = Service[$service_name]
  }else{
    $manage_service_autorestart =  undef
  }

  if $use_epel {
    $pkg_require = Class['Epel']
  } else {
    $pkg_require = undef
  }

  package { $package_name:
    ensure  => $fail2ban_ensure,
    require => $pkg_require,
  }

  service { $service_name:
    ensure  => $service_ensure,
    enable  => $manage_service_enable,
    require => Package[$package_name],
  }

  file { $config_file:
    ensure  => $manage_file,
    mode    => $config_file_mode,
    owner   => $config_file_owner,
    group   => $config_file_group,
    content => template($config_file_template),
    require => Package[$package_name],
    notify  => $manage_service_autorestart,
  }

  if $source_dir {
    file { $config_dir:
      ensure  => directory,
      mode    => '0644',
      owner   => $source_dir_owner,
      group   => $source_dir_group,
      recurse => true,
      purge   => $source_dir_purge,
      force   => $source_dir_purge,
      source  => $source_dir,
      require => Package[$package_name],
      notify  => $manage_service_autorestart,
    }
  }

  if $jails_config == 'file' {
    if $jails_content or $manage_file == 'absent' {
      file { $jails_file:
        ensure  => $manage_file,
        mode    => $jails_file_mode,
        owner   => $jails_file_owner,
        group   => $jails_file_group,
        content => $jails_content,
        require => Package[$package_name],
        notify  => $manage_service_autorestart,
      }
    }else{
      fail('jails_config => file without content and with fail2ban_ensure => present')
    }
  }

}
