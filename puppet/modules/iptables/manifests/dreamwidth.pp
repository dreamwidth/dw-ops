###############################################################################
# Dreamwidth iptables specification
# Xenacryst, 16-MAR-2009
###############################################################################

class iptables::dreamwidth inherits iptables {
    iptables::rules { "dreamwidth": ensure => present }
}
