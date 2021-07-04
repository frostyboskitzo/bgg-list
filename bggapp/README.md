# bgg-list
a simple app to list bgg games and things. I'm not very good so this probably won't work.

## Setup
This will probably be ruby. So, following Infrastructure as code, let's go with something like
-> Build for support with Debian, other linux systems should work, YMMV, windows probably not because windows does not go well in ruby.
-> Ruby:latest as on 04/JULY/2021, managed using RVM
-> Postgres for the database, it's easy.

### Dev environment build:
As a note: apps like this should not be run as root. I use a user called "bggapp"
* apt install curl
* useradd bggapp
* usermod --shell /bin/bash bggapp

Switch to bggapp user

* su bggapp

We're going to use RBENV: As the user bggapp, run:

* sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
* cd ~
* curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
* echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
* echo 'eval "$(rbenv init -)"' >> ~/.bashrc
* source ~/.bashrc

Check that it works:
* rbenv -v

Install Ruby:
* rbenv install -l
* rbenv install 2.7.3
* rbenv global 2.7.3

(Cause I'm lazy I also add this user to sudoers in dev, not recommended for prod.)

Ensure it all works:

* ruby -v

For postgres we're just going with stable:
* apt install postgresql
* systemctl start postgresql
* systemctl enable postgresql
* systemctl status postgresql
* passwd postgres

Configure that silly bastard a good password. Default secrets.yml.example ships with `bggapppass`

* su - postgres
* createdb bggapp

You will need to update the apps secrets.yml with the database details as you've configured them.

Lucky last some dependencies:
* gem install rails
* apt install libpq-dev
* rails new bggapp -d postgresql

That should have the ruby and rails all up and running.

Next lets get the web socket workers... working.

* sudo vim /etc/apt/sources.list

add:
```
deb https://nginx.org/packages/mainline/debian/ <CODENAME> nginx
deb-src https://nginx.org/packages/mainline/debian/ <CODENAME> nginx
```
* sudo apt remove nginx nginx-common
* sudo apt update
* sudo apt install nginx
* sudo nginx

Now for unicorn - the repo includes the unicorn config, and the Gemfile will install the gems you need, but you'll need to create the services.

* sudo vi /etc/init.d/unicorn_bggapp

add the following, tweaking your path and appname as necessary. Use the default bggapp if you're keen.
```
#!/bin/sh

### BEGIN INIT INFO
# Provides:          unicorn
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the unicorn app server
# Description:       starts unicorn using start-stop-daemon
### END INIT INFO

set -e

USAGE="Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"

# app settings
USER="bggapp"
APP_NAME="bggapp"
APP_ROOT="/var/www/app/$APP_NAME"
ENV="production"

# environment settings
PATH="/home/$USER/.rbenv/shims:/home/$USER/.rbenv/bin:$PATH"
CMD="cd $APP_ROOT && bundle exec unicorn -c config/unicorn.rb -E $ENV -D"
PID="$APP_ROOT/shared/pids/unicorn.pid"
OLD_PID="$PID.oldbin"

# make sure the app exists
cd $APP_ROOT || exit 1

sig () {
  test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
  test -s $OLD_PID && kill -$1 `cat $OLD_PID`
}

case $1 in
  start)
    sig 0 && echo >&2 "Already running" && exit 0
    echo "Starting $APP_NAME"
    su - $USER -c "$CMD"
    ;;
  stop)
    echo "Stopping $APP_NAME"
    sig QUIT && exit 0
    echo >&2 "Not running"
    ;;
  force-stop)
    echo "Force stopping $APP_NAME"
    sig TERM && exit 0
    echo >&2 "Not running"
    ;;
  restart|reload|upgrade)
    sig USR2 && echo "reloaded $APP_NAME" && exit 0
    echo >&2 "Couldn't reload, starting '$CMD' instead"
    $CMD
    ;;
  rotate)
    sig USR1 && echo rotated logs OK && exit 0
    echo >&2 "Couldn't rotate logs" && exit 1
    ;;
  *)
    echo >&2 $USAGE
    exit 1
    ;;
esac
```

* sudo systemctl start unicorn_bggapp
* sudo systemctl enable unicorn_bggapp

Check that it's working with `systemctl status unicorn_bggapp`

That should be about it for environment. Plug in your NGINX config with your hostname to talk to your unicorn workers.

With ruby and the files and the database, and secrets.yml configured, you should be able to install bundler and install the app.

### The Ruby Bit

If your environment is set up, here's the deploy:

For first time setup:
* rails g active_admin:install
* rails db:migrate
* rails db:seed
* rails server

Visit http://localhost:3000/admin and log in as the default user:

    User: admin@example.com
    Password: password

TBC
