#
# serverclass::perlbal
#
# Defines functionality for the configuration of the Perlbal machines.
#
# Authors:
#      Mark Smith <mark@dreamwidth.org>
#
# Copyright (c) 2009 by Dreamwidth Studios, LLC.
#
# This program is free software; you may redistribute it and/or modify it under
# the same terms as Perl itself.  For a copy of the license, please reference
# 'perldoc perlartistic' or 'perldoc perlgpl'.
#

class iptables::dreamwidth::perlbal inherits iptables::dreamwidth {
    # open up incoming port 80 and 443
    Iptables::Rules["dreamwidth"] { allowed_ports => [ 80, 443 ] }
}

class serverclass::perlbal inherits serverclass::dreamwidth {
    include iptables::dreamwidth::perlbal

    # make sure Apache is not running
    service { "apache2":
        ensure => stopped,
        pattern => "/usr/sbin/apache2",
        hasstatus => true,
        hasrestart => true
    }
}
