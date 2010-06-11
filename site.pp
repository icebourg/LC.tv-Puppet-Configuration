#
# A very simple puppet configuration.
#

# first, import all our classes loaded in the classes folder
import "classes/*.pp"

# now define the defauls for all nodes

node default {

	# we want roadrunner to be have an account

	add_user { rrunner:
                email    => "road.runner@acme.com",
                uid      => 5001
        }

	# and we want roadrunner to be able to login via ssh keys
	#  CAREFUL: We don't Wiley E Coyote to gain access to the private key
	# or it will be GAME OVER

	add_ssh_key { rrunner:
                key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAwtnN3Nmkn8WKfBUs4/AwCmthfsY6TXmEe63d2Okeo3QtpUvceXj83bVqerK6h62bEGb7LtE2oW8utiE8ZlWmeViMdIZo6OQVOMj69HgPZu3IKSIYW5hTVWhb5FmQOOtGk5m1uxJyeBI5ivmVJtQIrH6gOkoOP1X23PqLCUnb1Wur9J6NCAOOLtJQEl+CMTSRqNZ6VU/4Kvu0FxSiAqHdi5i4zpob3HIWXSC0Ugh664jqvjjJI7ZLuC4Ym3BFK+uZKVX3yKIx0sbiZm+IMBvuUJzmpfPTMPrMyZuq7FxSUjIv+TX4XKwxv8ysU39k1WllOYT5kDwkOnJ5NLt4zqJQVQ==",
                type    => "ssh-rsa"
        }

	# we can add other classes, rules and other information we want all our nodes
	# to get here. But for now, this is enough so end the node statement.

}
