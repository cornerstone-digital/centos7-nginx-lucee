centos7-nginx-lucee
==================

**NOTE:** This is a fork of Foundeo's [unbuntu-nginx-lucee](https://github.com/foundeo/ubuntu-nginx-lucee) project. If you are running Ubuntu, please see that repository.

A set of bash scripts for standing up a Lucee server using nginx and Tomcat on CentOS 7. Uses the
Tomcat from the CentOS 7 distribution so you can update Tomcat using `yum update tomcat7`

Why would I use this instead of the offical Lucee installers?
-------------------------------------------------------------

* You want to run nginx as your web server
* You want to update Tomcat via `yum`

What does it do?
----------------

1. **Updates CentOS 7** - simply runs `yum update` and `yum upgrade`
2. **Downloads Lucee** - uses curl to download lucee jars from BitBucket places jars in `/opt/lucee/current/`
3. **Installs & Configures Tomcat 7** - runs `yum install tomcat7` updates the `web.xml` `server.xml` and `catalina.properties` to configure Lucee servlets and mod_cfml Valve.
4. **Downloads & Installs Oracle JVM** - Downloads the Oracle JVM and installs it to `/opt/lucee/jvm/version` and then create a symbolic link `/opt/lucee/jvm/current` to denote the current JVM version to use. It also edits tomcat config to point to this JVM.
5. **Installs & Configures nginx** - runs `yum install nginx` to install nginx. Crates a web root directory. Creates a `lucee.config` file so you can just `include lucee.config` for any site that uses CFML

Take a look in the `scripts/` subfolder to see the script for each step.

How do I run it?
----------------

1. **Downlaod this repository** - `curl -Lo /tmp/centos7-nginx-lucee.tar.gz https://api.github.com/repos/dswitzer/centos7-nginx-lucee/tarball/master`
2. **Extract repository** - `tar -xzvf /tmp/centos7-nginx-lucee.tar.gz`
3. **Change to install folder** - Go to the install folder `cd /tmp/dswitzer-centos-nginx-lucee-abcdefg/`
4. **Edit the `install.sh`** - Change any configuration options such as the Lucee Version or JVM version.
5. **Make `install.sh` executable** - you may need to `chmod u+x install.sh` to give execute permissions to the script.
6. **Run install.sh** - make sure you are root or sudo and run `./install.sh`.
7. **Set Lucee Passwords** - login to `/lucee/admin/server.cfm` and set the server password, and also set the default web context password.

Limitations / Known Issues
--------------------------

* The servlet definitions and mappings (located in `/etc/tomcat7/web.xml`) are slimmed down, so if you need things like REST web services, flash/flex remoting support see the [Railo docs for web.xml config](https://github.com/getrailo/railo/wiki/Configuration:web.xml)
* The `/lucee/` uri is blocked in `/etc/nginx/lucee.conf` you must add in your ip address and restart nginx.
* There is no uninstall option
* This script has been tested on CentOS 7 only


Setting up a Virtual Host
-------------------------

By default nginx on CentOS 7 looks in the folder `/etc/nginx/sites-enabled/` for configuration nginx files. To setup a site create a file in that folder (another technique you can use is to create the file in `/etc/nginx/sites-avaliable/` and then create a symbolic link in sites-enabled to enable the site), for example `/etc/nginx/sites-enabled/me.example.com.conf` at a minimum it will look like this:

	server {
		listen 80;
		server_name me.example.com;
		root /web/me.example.com/wwwroot/;
		include lucee.conf;
	}

You may also want to break logging for this site out into its own file, like this:

	server {
		listen 80;
		server_name me.example.com;
		root /web/me.example.com/wwwroot/;
		access_log /var/log/nginx/me.example.com.access.log;
		error_log /var/log/nginx/me.example.com.error.log;
		include lucee.conf;
	}

If you don't need Lucee/CFML for a given site, simply omit the `include lucee.conf;` line, like this:

	server {
		listen 80;
		server_name img.example.com;
		root /web/img.example.com/wwwroot/;
	}

After making changes you need to restart or reload nginx:

	sudo service nginx restart

For more information on configuring nginx see the [nginx Wiki](http://wiki.nginx.org/Configuration)

Thanks go to [Booking Boss](http://www.bookingboss.com/) for funding the initial work on this script.
