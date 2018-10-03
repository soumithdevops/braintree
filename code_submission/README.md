### Introduction

This archive contains a simple credit card processing application. It has two
components: a Ruby web and application server beelzebub (using the Sinatra
framework, and running under Unicorn), and a requester which simulates making
requests against the server. The server receives the requests and writes them
to its data directory. The server also logs each transaction's start time and
completion time via syslog.

This archive also contains a virtual machine configuration, a `Vagrantfile`,
which is provided for your use as a test environment. This is used with
[Vagrant](https://www.vagrantup.com/), a command line utility for managing
the lifecycle of virtual machines. We strongly recommend that you use this
environment, to ensure consistency between your development and our testing.

### Installation

1. Setup Vagrant.

    * Official instructions: https://www.vagrantup.com/docs/installation/
    * With Homebrew: `brew cask install virtualbox && brew cask install vagrant`

2. Start the test environment using the provided `Vagrantfile`.

    * Change into the directory containing the provided `Vagrantfile`
    * Start the virtual machine: `vagrant up --provider virtualbox`
    * Enter the virtual machine: `vagrant ssh`

### Running

1. Beelzebub is started in the virtual machine by default from systemd.
To check its status, run:

        sudo systemctl status beelzebub

2. Start the requester:

        BUNDLE_GEMFILE=/opt/beelzebub/requester bundle exec /opt/beelzebub/requester

### Challenge

Compose two programs which conform to the Nagios Plugin API (linked below)
that will monitor beelzebub:

1. Create a program which can monitor the number of transaction files that the
   Unicorn process has open for access. The transaction files are of the form
   `data/*.yaml`. This program should accept `--warning` and
   `--critical` thresholds for the number of open transaction files.

        check_beelzebub_open_files --warning 10 --critical 20

2. Create a program that can analyze transaction history for a given time
   period. If the average transaction response time (difference between
   `started` and `completed` time) exceeds a given threshold over that time
   period, the program should alert. This program should accept
   `--warning` and `--critical` threshold arguments for the average
   response time in seconds, and a `--time-period` argument that
   specifies the time window to analyze in seconds. Do not modify the
   application server or the requester.

        Example:
        check_beelzebub_tx_response_time --time-period 300 --warning 2 --critical 3

   This would WARN if the analysis of the response times in the past
   5 minutes shows an average of between 2 and 3 seconds.

Please assume that Nagios will check every minute, so the check should complete
in less than 30 seconds.  Additionally, you do not need to actually run your
programs inside Nagios: they will be evaluated by running them directly
from the command line.  You need only make sure you conform to the
requirements of the Nagios Plugin API, which can be referenced here:

  * <https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/3/en/pluginapi.html>

With your submission, please include a README that details:

  1. Any necessary runtime or compile dependencies
  2. Instructions for compiling and running your checks
  3. Any assumptions you made
  4. Why you picked the programming language you used

### Recommendations

  * Use a language you are familiar and confident with
  * Organization, simplicity, and packaging are as important as functionality

### Submission

Please email your submission back to the Braintree recruiting team in an
archive format of your choice. Do not post your solution on GitHub or any other
public forum. You only need to include your two checks, which can be invoked
standalone, and a README (in plain text or markdown.) Please do not submit a
Docker/VirtualBox/etc. image.

Your submission will be evaluated anonymously, so refrain from adding your name
or other identifying information to the files you submit.

** Note: This information is confidential. It is prohibited to share, post
online or otherwise publicize without Braintree's prior written consent. **
