group { "puppet":
     ensure => "present",
}
include java

node "opencms.cc.de" {
	include '::mysql::server' 	
	include tomcat
	Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
	
	package { "unzip":
		ensure => "installed",
		require => [Exec['apt-update'],],
	}
	exec { "apt-update":
		command	=> "/usr/bin/apt-get update",
	}

	exec { "wget opencms":
		command => "wget http://www.opencms.org/downloads/opencms/opencms-9.0.1.zip",
		cwd	=> "/vagrant/files/",
		timeout => 0,
		path	=> "/usr/bin",
	}

	file { "/var/lib/tomcat6/webapps/opencms-9.0.1.zip":
		ensure	=> present,
		source	=> "/vagrant/files/opencms-9.0.1.zip",
		owner	=> root,
		mode	=> 777,
		require => Exec['wget opencms'],
	}

	exec { "unzip-opencms":
		command => "unzip -o /var/lib/tomcat6/webapps/opencms-9.0.1.zip -d /var/lib/tomcat6/webapps",
		path	=> "/usr/bin",
		require => File['/var/lib/tomcat6/webapps/opencms-9.0.1.zip'],
		user => "root",
	}
}

class { '::mysql::server':
  root_password    => 'toor',
  databases	=> { 'opencms' => {'ensure' => 'present'}},
  users		=> { 'opencms@localhost' => {'ensure' => 'present'
			, password_hash => mysql_password(opencms),},},
  grants	=> { 'opencms' => {'ensure' => 'present',
			privileges  => ["ALL"],
        		table       => "*.*",
		        user        => "opencms@localhost",
		}, },
override_options => { 'mysqld' => { 'max_allowed_packet' => '64M' } }
}

#class { '::mysql::server::providers':
#	create_resources('mysql_database', $mysql::server::databases)
#}
