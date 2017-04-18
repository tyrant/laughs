# Laughs

So this little baby runs a web script for the websites of various comedians - Jimmy Carr, Eddie Izzard, etc., looks over their Upcoming Gigs pages, and displays them on a Google map. The user can then filter by comedian, location, start/end dates. 

You can see it in action at sciencethisbitchup.com.

## Starting services

### Memcached

On Development: `memcached`

### Start the database on OSX/MacOS

The page http://stackoverflow.com/questions/7975556/how-to-start-postgresql-server-on-mac-os-x is a godsend, check that out.

Step One: `pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`



## Setting up a Production server

* Hooking into this repo
* Install Nginx
* Install Phusion Passenger
* Install Ruby
* Git clone
* 