# Class: fail2ban::params
#
# This class manages fail2ban parameters.
#
#
class fail2ban::params {
  $package_name           = 'fail2ban'
  $service_name           = 'fail2ban'
  $config_dir             = '/etc/fail2ban'
  $config_file            = '/etc/fail2ban/fail2ban.local'
  $config_file_mode       = '0644'
  $config_file_owner      = 'root'
  $config_file_group      = 'root'
  $config_file_template   = 'fail2ban/fail2ban.local.erb'
  $disableboot            = false
  $service_autorestart    = true
  $fail2ban_ensure        = 'present'
  $service_ensure         = 'running'
  $source_dir             = undef
  $source_dir_owner       = 'root'
  $source_dir_group       = 'root'
  $source_dir_purge       = false
  $jails_config           = undef
  $jails_file             = '/etc/fail2ban/jail.local'
  $jails_file_mode        = '0644'
  $jails_file_owner       = 'root'
  $jails_file_group       = 'root'
  $jails_content          = undef
  $jails_template_header  = 'fail2ban/concat/jail.local-header.erb'
  $jails_template_footer  = 'fail2ban/concat/jail.local-footer.erb'
  $default_ignoreip       = ['127.0.0.1/8']
  $default_bantime        = '600'
  $default_findtime       = '600'
  $default_maxretry       = '5'
  $backend                = 'auto'
  $mailto                 = "hostmaster@${facts['networking']['domain']}"
  $banaction              = 'iptables-multiport'
  $mta                    = 'sendmail'
  $default_jails_protocol = 'tcp'
  $jails_chain            = 'INPUT'
  $use_epel               = false
  $log_level              = undef
  $log_target             = undef

  case $facts['os']['family'] {
    'RedHat': {}
    default: {
      fail("Unsupported platform: ${facts['os']['family']}/${facts['os']['name']}")
    }
  }
}
