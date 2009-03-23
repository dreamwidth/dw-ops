###############################################################################
# Dreamwidth apache2 class
# Xenacryst, 13-MAR-2009
#
# Similar to debian class, except it:
#  - uses the dw.conf file
#  - adds the apreq module (required by Dreamwidth)
#  - adds the deflate module (default in Ubuntu)
#  - disables the "default" site
#
# Note: the default site installed by Apache2 is disabled in init.pp.
###############################################################################

class apache2::dreamwidth inherits apache2 {
  $apache2_mpm = "prefork"

  apache2::config { "base": order => "000", ensure => present }
  apache2::config { "security": order => "010", ensure => present }
  apache2::config { "mpm-prefork": order => "020", ensure => present }
  apache2::config { "logging-errorlog": order => "030", ensure => present }
  apache2::config { "ports": order => "040", ensure => present }
  apache2::config { "dw": order => "900", ensure => present }

  apache2::module { ["alias", "apreq", "auth_basic", "authn_file", 
    "authz_default", "authz_groupfile", "authz_host", 
    "authz_user", "autoindex", "cgid", "deflate", "dir", "env", "mime", 
    "negotiation", "perl", "setenvif", "status"]:
    ensure=> present,
  }
}
