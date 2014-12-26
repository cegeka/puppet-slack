slack {
  slack_webhook => 'INSERT_WEBHOOK',
  slack_channel => '#puppet',
  slack_username => 'Puppet',
  slack_icon_url => 'https://pbs.twimg.com/profile_images/3672925108/954f7381089ac290b4690c5ffd9dd7d3.png',
  slack_statuses => [ 'failed', 'changed' ],
  foreman_api_host => 'INSERT_FOREMAN_URL'
}
