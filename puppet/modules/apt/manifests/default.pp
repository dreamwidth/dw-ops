###############################################################################
# Default apt sources.list
# Recreates Intrepid sources for a US-based archive
# Xenacryst, 15-MAR-2009
###############################################################################

class apt::default inherits apt {
    apt::sources { "default":
	ensure => present,
	host => 'us.archive.ubuntu.com',
	release => 'intrepid'
    }
}
