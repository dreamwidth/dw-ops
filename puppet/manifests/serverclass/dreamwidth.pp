###############################################################################
# General Dreamwidth server class
# Xenacryst, 10-MAR-2009
###############################################################################

###############################################################################
# Base class for all Dreamwidth servers managed by Puppet
class serverclass::dreamwidth {
    # APT module
    include apt::dreamwidth

    # IPTABLES module
    include iptables::dreamwidth

    # PUPPET module (client)
    include puppet
    puppet::client { $hostname: ensure => present }

    # Local "dw" user and group
    group { dw:
        ensure => present
    }
    user { dw:
        ensure => present,
        comment => "Dreamwidth",
        home => "/home/dw",
        managehome => true,
        gid => "dw",
        shell => "/bin/bash",
        require => Group["dw"]
    }

    # Ensure that "dw" user can run sudo
    line { sudo_dw:
        file => "/etc/sudoers",
        line => "dw ALL=NOPASSWD: ALL",
        ensure => present
    }

    # Packages to install
    # (Apache2 and mpm packages are installed in the apache2 module)
    package {
        dh-make-perl:;
        libapache2-mod-perl2:;
        libapache2-request-perl:;
        libcaptcha-recaptcha-perl:;
        libclass-accessor-perl:;
        libclass-autouse-perl:;
        libclass-data-inheritable-perl:;
        libclass-trigger-perl:;
        libcompress-zlib-perl:;
        libcrypt-dh-perl:;
        libdatetime-perl:;
        libdbd-mysql-perl:;
        libdbi-perl:;
        libdigest-hmac-perl:;
        libdigest-sha1-perl:;
        libgd-gd2-perl:;
        libgd-graph-perl:;
        libgnupg-interface-perl:;
        libgtop2-dev:;
        libhtml-parser-perl:;
        libhtml-tagset-perl:;
        libhtml-template-perl:;
        libimage-size-perl:;
        libio-stringy-perl:;
        libmail-gnupg-perl:;
        libmailtools-perl:;
        libmath-bigint-gmp-perl:;
        libmd5-perl:;
        libmime-lite-perl:;
        libmime-perl:;
        libnet-dns-perl:;
        libproc-process-perl:;
        librpc-xml-perl:;
        libsoap-lite-perl:;
        libstring-crc32-perl:;
        libtext-vcard-perl:;
        libunicode-maputf8-perl:;
        liburi-fetch-perl:;
        liburi-perl:;
        libwww-perl:;
        libxml-atom-perl:;
        libxml-rss-perl:;
        libxml-simple-perl:;
        mercurial:;
        mysql-client:;
        perlmagick:;
        puppet:;
        screen:;
        subversion:;
        vim-perl:;
    }
}
