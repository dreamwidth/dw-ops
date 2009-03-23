###############################################################################
# Class for managing iptables rule files
# Xenacryst, 14-MAR-2009
#
# Actions:
#  * install /etc/network/if-pre-up.d/iptables script
#  * install /etc/iptables.up.rules as directed by rules()
#  * run iptables-restore whenever rules change
#
# To use the rules() function:
# Arguments (both optional):
#  ensure: present (default) absent
#  content: alternate content specification
# This function searches for a template called $name.erb and writes the
# /etc/iptables.up.rules file from that.  If the template includes any
# variables, you can specify them before calling the rules() function.
###############################################################################

class iptables {
    # ensure that the iptables network initialization script is present
    file { "/etc/network/if-pre-up.d/iptables":
	ensure => present,
	mode => 755,
	owner => root,
	group => root,
	source => "puppet://$servername/iptables/iptables"
    }

    # run the iptables-restore program to reload the rules
    # only run this when requested (refreshonly)
    exec { "iptables-restore":
	command => "/sbin/iptables-restore < /etc/iptables.up.rules",
	refreshonly => true
    }

    # Load the iptables rules, write the file, and notify the iptables-restore
    # exec to reload the rules
    define rules ( $ensure = 'present', $content = '' ) {
	$real_content = $content ? {
		'' => template ("iptables/${name}.erb"),
		default => $content
	}

	file { "/etc/iptables.up.rules":
	    ensure => $ensure,
	    content => $real_content,
	    mode => 444,
	    owner => root,
	    group => root,
	    notify => Exec["iptables-restore"]
	}
    }
}
