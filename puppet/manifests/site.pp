###############################################################################
# Puppet site configuration for Dreamwidth
# Xenacryst, 10-MAR-2009
###############################################################################

###############################################################################
# Function: line()
# Decription: ensures that a line in a text file is present or absent
#  by appending the line to the end of the file or removing it as required.
# Arguments:
#  file: the text file to modify
#  line: the exact text of the line
#  ensure: "present" (default) or "absent"
#  Other standard arguments (require, notify, etc.) can be present
# Usage:
#   line { description:
#         file => "filename",
#         line => "content",
#         ensure => {absent,*present*}
#   }
#
define line($file, $line, $ensure = 'present') {
    case $ensure {
        default : { err ( "unknown ensure value '${ensure}'" ) }
        present: {
             exec { "/bin/echo '${line}' >> '${file}'":
                unless => "/bin/grep -qFx '${line}' '${file}'"
            }
        }
        absent: {
            exec { "/usr/bin/perl -ni -e 'print if \$_ ne \"${line}\n\";' '${file}'":
                onlyif => "/bin/grep -qFx '${line}' '${file}'"
            }
        }
    }
}
###############################################################################


###############################################################################
# DREAMWIDTH SITE SPECIFICATION
#
#
# define server, used in some templates.  note that we can't use $servername
# in the particular setup DW is using...
$server = 'puppet'

# Import the standard Dreamwidth server classes
import "serverclass/*"

# NODE SPECIFICATION
# There are two main server classes: webserver and nonwebserver.  The
# webserver class loads the apache2 class with Dreamwidth specific configs
# and makes sure that Apache is running.  The nonwebserver class makes sure
# that Apache is not running.  Both inherit the packages, apt settings, and
# iptables configuration from the main dreamwidth class.
#
# node nodename { include serverclass::webserver }
#  -OR-
# node nodename { include serverclass::nonwebserver }

node dfw-mail01 { include serverclass::mail    }
node dfw-lb01   { include serverclass::perlbal }
node dfw-lb02   { include serverclass::perlbal }
node dfw-lb03   { include serverclass::perlbal }
node dfw-lb04   { include serverclass::perlbal }

# A special case exists for the node that will run the Puppet master service.
# This node can be specified as following:
#
#  node puppetmaster {
#    include serverclass::whatever
#    puppet::server { $hostname: ensure => present }
#  }
#
# This will distribute the puppetmasterd.conf file and start the puppetmaster
# service to that node.

# If the node is not found, the "default" node will be used, as below, which
# loads the nonwebserver class.
node default { include serverclass::nonwebserver }
###############################################################################
