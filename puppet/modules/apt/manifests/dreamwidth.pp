###############################################################################
# Dreamwidth sources.list
# Xenacryst, 15-MAR-2009
#
# Use the local Dreamwidth package cache, available on port 9999, using
# Ubuntu Hardy.
###############################################################################

class apt::dreamwidth inherits apt {
    apt::sources { "dreamwidth":
	ensure => present,
	host => 'dfw-admin01',
	port => '9999',
	release => 'intrepid'
    }
}
