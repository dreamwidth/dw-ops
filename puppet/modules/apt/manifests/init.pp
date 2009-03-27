###############################################################################
# apt sources class
# Xenacryst, 14-MAR-2009
#
# This installs /etc/apt/sources.list with the given template and values
###############################################################################

class apt {
    define sources (
        $ensure = 'present',
        $host = 'us.archive.ubuntu.com',
        $port = '',
        $release,
        $content = ''
    ) {
        $apt_uri = $port ? {
            '' => $host,
            default => "$host:$port"
        }

        $ubuntu_release = $release

        $real_content = $content ? {
            '' => template ("apt/$name.erb"),
            default => $content
        }

        file { "/etc/apt/sources.list":
            ensure => $ensure,
            content => $real_content,
            mode => 444,
            owner => root,
            group => root
        }
    }
}
