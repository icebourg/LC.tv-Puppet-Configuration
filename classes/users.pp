define add_user ( $email, $uid ) {

        $username = $title

	# Create the user. This is where most of the magic happens.
        user { $username:
                comment => "$email",
                home    => "/home/$username",
                shell   => "/bin/bash",
                uid     => $uid
        }

	# Ensure we have a group by the same name / id.
        group { $username:
                gid     => $uid,
                require => user[$username]
        }

	# Make sure they have a home with proper permissions.
	# Had a problem where this would fire before a group was created,
	# so I added the group definition above to be explicit, then made this
	# require that the group exists before executing.
        file { "/home/$username/":
                ensure  => directory,
                owner   => $username,
                group   => $username,
                mode    => 750,
                require => [ user[$username], group[$username] ]
        }

	# And a place with the right permissions for the SSH related configs
        file { "/home/$username/.ssh":
                ensure  => directory,
                owner   => $username,
                group   => $username,
                mode    => 700,
                require => file["/home/$username/"]
        }

	# This line is the only thing unique in this file. I am not (yet anyway)
	# giving you the setuserpassword.sh file below, or the puppet files to generate
	# narnia. You can substitute with your own script easily enough. When I clean this
	# up I will probably include this code too. Just be forewarned that you WILL need
	# to do some customizing here.

        exec { "/narnia/tools/setuserpassword.sh $username":
                path            => "/bin:/usr/bin",
                refreshonly     => true,
                subscribe       => user[$username],
                unless          => "cat /etc/shadow | grep $username| cut -f 2 -d : | grep -v '!'"
        }

        # Now make sure that the ssh key authorized files is around

        file { "/home/$username/.ssh/authorized_keys":
                ensure  => present,
                owner   => $username,
                group   => $username,
                mode    => 600,
                require => file["/home/$username/.ssh"]
        }

}

# Now we want to be able to utilize ssh public keys for authentication. This definition
# makes that happen.
# It's just a very thin wrapper around the ssh_authorized_key built-in type so you may
# not find it 100% necessary. I like having the standardized requires personally and
# may not always remember it without a definition.

define add_ssh_key( $key, $type ) {

        $username       = $title

        ssh_authorized_key{ "${username}_${key}":
                ensure  => present,
                key     => $key,
                type    => $type,
                user    => $username,
                require => file["/home/$username/.ssh/authorized_keys"]
        }

}
