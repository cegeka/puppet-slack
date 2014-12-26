# Class: slack
#
# This module manages slack
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class slack (
  $slack_webhook = undef,
  $slack_channel = '#puppet',
  $slack_username = 'Puppet',
  $slack_icon_url = 'https://pbs.twimg.com/profile_images/3672925108/954f7381089ac290b4690c5ffd9dd7d3.png',
  $slack_statuses = [ 'failed', 'changed' ],
  $foreman_api_host = 'UNSET',
  $slack_puppet_dir = '/etc/puppet'
){

  file { "${slack_puppet_dir}/slack.yaml":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('slack/slack.yaml.erb'),
  }

}

