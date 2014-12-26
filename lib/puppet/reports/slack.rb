require 'json'
require 'net/https'
require 'open-uri'
require 'puppet'
require 'uri'
require 'yaml'

begin
  require 'slack-notifier'
rescue LoadError => e
  Puppet.info "You need the `slack-notifier` gem to use the Slack report"
end

Puppet::Reports.register_report(:slack) do

  configfile = File.join([File.dirname(Puppet.settings[:config]), "slack.yaml"])
  raise(Puppet::ParseError, "Slack report config file #{configfile} not readable") unless File.exist?(configfile)

  config = YAML.load_file(configfile)

  SLACK_WEBHOOK = config[:slack_webhook]
  SLACK_CHANNEL = config[:slack_channel] || '#puppet'
  SLACK_USERNAME = config[:slack_username] || 'Puppet'
  SLACK_ICON_URL = config[:slack_icon_url]
  SLACK_STATUSES = Array(config[:slack_statuses] || 'failed')

  DISABLED_FILE = File.join([File.dirname(Puppet.settings[:config]), 'slack_disabled'])
  FOREMAN_API_HOST = config[:foreman_api_host] || 'UNSET'

  desc <<-DESC
  Send notification of failed reports to a Slack channel.
  DESC

  def process
    # Disabled check here to ensure it is checked for every report
    disabled = File.exists?(DISABLED_FILE)

    if (SLACK_STATUSES.include?(self.status) || SLACK_STATUSES.include?('all')) && !disabled
      Puppet.info "Sending status for #{self.host} to Slack channel #{SLACK_CHANNEL}"

      msg = "Puppet run executed on #{self.host} with status `#{self.status}` at #{Time.now.asctime}"
      report_note = {}

      status_color = case self.status
                     when 'failed' then '#D00000'
                     when 'changed' then '#4572A7'
                     else '#89A54E'
                     end

      if FOREMAN_API_HOST != 'UNSET'
        uri = URI.parse('%s/api/hosts/%s/reports/last' % [ FOREMAN_API_HOST, self.host ] )
        http = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https' then
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        @data = response.body

        json = JSON.parse(@data)
        reportid = json['report']['id']
        msg = "Puppet run executed on <#{FOREMAN_API_HOST}/hosts/#{self.host}|#{self.host}> "
        msg += "with status `#{self.status}` at #{Time.now.asctime}"
        report_note = {
          text: "<#{FOREMAN_API_HOST}/reports/#{reportid}|View Report>",
          color: status_color
        }
      end

      notifier = Slack::Notifier.new SLACK_WEBHOOK
      notifier.channel  = SLACK_CHANNEL
      notifier.username = SLACK_USERNAME
      notifier.ping msg, icon_url: ICON_URL, attachments: [report_note]
    end
  end

end
