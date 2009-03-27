###############################################################################
# Dreamwidth server class for servers that are *not* webservers
# Xenacryst, 10-MAR-2009
#
# All this does is ensure that the apache2 service is stopped
###############################################################################

class serverclass::nonwebserver inherits serverclass::dreamwidth {
    # make sure Apache is not running
    service { "apache2":
        ensure => stopped,
        pattern => "/usr/sbin/apache2",
        hasstatus => true,
        hasrestart => true
    }
}
