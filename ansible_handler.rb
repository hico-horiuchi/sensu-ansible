#!/usr/bin/env ruby
# Sensu Ansible Handler

require 'sensu-handler'

class AnsibleHandler < Sensu::Handler
  def playbooks
    settings['ansible']['playbooks'] || '/etc/sensu/playbooks'
  end

  def typetalk_vars
    {
      client_id: settings['ansible']['typetalk_client_id'],
      client_secret: settings['ansible']['typetalk_client_secret'],
      topic: settings['ansible']['typetalk_topic']
    }
  end

  def generate_hostfile(event)
    client = event['client']['name']
    address = event['client']['address']
    check = event['check']['name']

    hostfile = "/tmp/#{Time.now.strftime '%y%m%d%H%M%S'}.hosts"
    typetalk = typetalk_vars

    File.open(hostfile) do |f|
      f.puts "[#{check}]"
      f.puts "#{client} ansible_ssh_host=#{address}"
      f.puts "[#{check}:vars]"
      f.puts "typetalk_client_id=#{typetalk[:client_id]}"
      f.puts "typetalk_client_secret=#{typetalk[:client_secret]}"
      f.puts "typetalk_topic=#{typetalk[:topic]}"
    end

    hostfile
  end

  def handle
    check = @event['check']['name']
    status = @event['check']['status']
    occurrences = @event['occurrences']
    return if status < 2 || occurrences > 1

    hostfile = generate_hostfile @event
    result = `ansible-playbook -i #{hostfile} #{playbooks}/#{check}.yml`
    unless $?.to_i == 0
      puts result
    end
  end
end
