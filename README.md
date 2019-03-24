# Icinga Result Client

This gem provides a library and executable to send passive check results via API to Icinga2.

## Installation

Require it in your Gemfile
```bash
gem 'icinga_result'
```

or install it directly via
```bash
gem install icinga_result
```

## Configuration

To use the gem you need a configuration file with an Icinga API host and user.

```yaml
---
username: your icinga username
password: your super secred icinga password
host: icinga.example.com
port: 5665
always_send_host_alive: false
```

"always_send_host_alive" sends the host alive signal every time a service result is delivered.

## Usage

### Command line client

You can deliver status results simple by calling `icinga-result`. While it is sufficient to supply "name", "status" and "message" when the service exists, you should probably always give as much information as you can. The first time a check result is sent, it will probably fail (since the service does not exist yet). But it will automatically be created and when the check is run a second time, the result will be sent.

```
$ icinga-result --help
Usage: --help [options]
        --service [NAME]             Service name
        --interval [INTERVAL]        Server check interval
        --description [DESCRIPTION]  Service description
        --status [STATUS]            Status code for the check
        --message [MESSAGE]          Status message for the check
        --performance-data [DATA]    Performance data for the check
        --host-alive                 Send host alive signal
```

### Library

When you implement your check in Ruby, you can call the library directly. A simple script might look like this:

```ruby
require 'icinga_result/client'

client = IcingaResult::Client.new
service = IcingaResult::Service.new('demo', interval: 3600, description: 'This is a demo check')

if my_special_check
  result = IcingaResult::CheckResult.new(0, 'Ok')
else
  result = IcingaResult::CheckResult.new(2, 'Special is borken!')
end

client.send(service, result)
```
