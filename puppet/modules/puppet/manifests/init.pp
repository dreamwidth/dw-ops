###############################################################################
# Puppet configuration file class
# Xenacryst, 16-MAR-2009
###############################################################################

class puppet {

    ################################################################
    # Puppet client definition:
    #   * Installs /etc/puppet/puppetd.conf
    #   * Starts the puppet service
    define client (
	$ensure = 'present',
	$source = ''
    ) {
	$real_source = $source ? {
	    '' => "puppet://$servername/puppet/puppetd.conf",
	    default => $source
	}

	service { puppet:
	    ensure => running,
	    require => File["/etc/puppet/puppetd.conf"]
	}

	file { "/etc/puppet/puppetd.conf":
	    ensure => $ensure,
	    source => $real_source,
	    mode => 444,
	    owner => root,
	    group => root,
	    notify => Service[puppetd]
	}
    }
    ################################################################

    ################################################################
    # Puppet server definition
    #  * Installs /etc/puppet/puppetmasterd.conf
    #  * Ensures necessary directories exist
    #  * Starts puppetmasterd service
    define master (
	$ensure = 'present',
	$source = ''
    ) {
	$real_source = $source ? {
	    '' => "puppet://$servername/puppet/puppetmasterd.conf",
	    default => $source
	}

	service { puppetmaster:
	    ensure => running,
	    require => File["/etc/puppet/puppetmasterd.conf"]
	}

	file { "/var/lib/puppet":
	    ensure => directory,
	    owner => puppet,
	    group => puppet
	}
	file { "/var/lib/puppet/modules":
	    ensure => directory,
	    owner => puppet,
	    group => puppet
	}
	file { "/var/lib/puppet/ssl":
	    ensure => directory,
	    owner => puppet,
	    group => puppet
	}
	file { "/var/log/puppet":
	    ensure => directory,
	    owner => puppet,
	    group => puppet
	}
	file { "/var/run/puppet":
	    ensure => directory,
	    owner => puppet,
	    group => puppet
	}

	file { "/etc/puppet/puppetmasterd.conf":
	    ensure => $ensure,
	    source => $real_source,
	    mode => 444,
	    owner => root,
	    group => root,
	    notify => Service[puppetmaster]
	}
    }
    ################################################################
}
