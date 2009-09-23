###############################################################################
# Dreamwidth sources.list
# Xenacryst, 15-MAR-2009
#
# Use the local Dreamwidth package cache, available on port 9999, using
# Ubuntu Jaunty.
###############################################################################

class apt::dreamwidth inherits apt {
    apt::sources { "dreamwidth":
        ensure => present,
        host => 'sb-admin01',
        port => '9999',
        release => 'jaunty'
    }
}
