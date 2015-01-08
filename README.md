puppet-slack module
===================

Description
-----------

A Puppet report handler for sending notifications of Puppet runs to [Slack](http://www.slack.com).

Installation & Usage
--------------------

1.  Install puppet-slack as a module in your Puppet master's module path.

2.  Create a Slack Incoming Webhooks integration and copy the URL that is generated.

3. Add the class to the puppet master node:

        class { 'slack':
          slack_webhook    => 'YOUR_SLACK_WEBHOOK',
          slack_channel    => '#puppet',
          slack_username   => 'Puppet',
          slack_icon_url   => 'https://pbs.twimg.com/profile_images/3672925108/954f7381089ac290b4690c5ffd9dd7d3.png',
          slack_statuses   => ['changed', 'failed'],
          foreman_api_host => 'YOUR_FOREMAN_HOST'
        }

4.  Enable pluginsync and reports on your master and clients in `puppet.conf`

        [master]
          report = true
          reports = slack
          pluginsync = true
        [agent]
          report = true
          pluginsync = true

5.  Run the Puppet client and sync the report as a plugin

6.  To temporarially disable Slack notifications add a file named 'slack_disabled' in the same path as slack.yaml.
	(Removing it will re-enable notifications)

		$ touch /etc/puppet/slack_disabled

