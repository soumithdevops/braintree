Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

package {
  [
    "bundler",
    "gawk",
    "parallel",
    "ruby",
    "vim",
  ]:
  ensure => installed,
}

package {
  [
    "mawk",
    "vim-tiny",
    "nano",
  ]:
  ensure => "purged",
}

user { "beelzebub":
  home   => "/opt/beelzebub",
  system => true,
}

file { "/opt/beelzebub":
  ensure  => "directory",
  owner   => "beelzebub",
  group   => "beelzebub",
  source  => "file:///vagrant/beelzebub",
  recurse => true,
}

file {
  [
    "/opt/beelzebub/tmp",
    "/opt/beelzebub/data",
    "/opt/beelzebub/log",
  ]:
  ensure  => "directory",
  owner   => "beelzebub",
  group   => "beelzebub",
}

file {
  [
    "/opt/beelzebub/tmp/pids",
    "/opt/beelzebub/tmp/sockets",
  ]:
  ensure  => "directory",
  owner   => "beelzebub",
  group   => "beelzebub",
}

exec { "bundle install --deployment":
  cwd     => "/opt/beelzebub",
  user    => "beelzebub",
  creates => "/opt/beelzebub/.bundle/config",
  require => [
    Package["bundler"],
    File["/opt/beelzebub"],
  ],
}

$beelzebub_service = @(END)
  [Unit]
  Description=Beelzebub

  [Service]
  WorkingDirectory=/opt/beelzebub
  ExecStart=/usr/bin/bundle exec unicorn -c /opt/beelzebub/unicorn.rb -l 0.0.0.0:8080
  ExecReload=/bin/kill -HUP $MAINPID
  Restart=on-abort
  User=beelzebub
  Group=beelzebub

  [Install]
  WantedBy=multi-user.target
  | END

file { "/etc/systemd/system/beelzebub.service":
  owner   => "root",
  group   => "root",
  content => $beelzebub_service,
}

service { "beelzebub":
  ensure  => "running",
  enable  => true,
  require => [
    File["/etc/systemd/system/beelzebub.service"],
    Exec["bundle install --deployment"],
  ],
}
