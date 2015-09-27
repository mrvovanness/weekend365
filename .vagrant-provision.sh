#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
set -e

if [ ! -f /home/vagrant/.provisioning-progress ]; then
  su vagrant -c "touch /home/vagrant/.provisioning-progress"
  echo "--> Progress file created in /home/vagrant/.provision-progress"
  apt-get update
else
  echo "--> Progress file exists in /home/vagrant/.provisioning-progress"
fi

# Set the system locale
if grep +locale .provisioning-progress; then
  echo "--> locale already set, moving on."
else
  echo "--> Setting the system locale..."
  echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale
  locale-gen en_US.UTF-8
  update-locale LANG=en_US.UTF-8
  su vagrant -c "echo +locale >> /home/vagrant/.provisioning-progress"
  echo "--> Locale is now set."
fi

# Install git, build-essential, curl
if grep -q +core-libs .provisioning-progress; then
  echo "--> Core libs (git, curl, nodejs, etc) already installed, moving on."
else
  echo "--> Installing core libs (git, curl, nodejs etc)..."
  apt-get -y install build-essential curl git-core python-software-properties
  apt-get -y install nodejs # needed by Rails to have a Javascript runtime
  apt-get -y install zlib1g-dev libssl-dev libreadline6-dev libyaml-dev libncurses5-dev libxml2-dev libxslt-dev
  su vagrant -c "echo +core-libs >> /home/vagrant/.provisioning-progress"
  echo "--> Core libs (git, curl, nodejs etc) are now installed."
fi

# Default folder to /vagrant
if grep -q +default/vagrant .provisioning-progress; then
  echo "--> default/vagrant already configured"
else
  echo "--> configuring default /vagrant"
  sudo -u vagrant printf 'cd /vagrant\n' >> /home/vagrant/.profile
  su vagrant -c "echo +default/vagrant >> /home/vagrant/.provisioning-progress"
  echo "--> default/vagrant is now configured."
fi

# Install ruby
if grep -q +ruby/2.2.2 .provisioning-progress; then
  echo "--> ruby-2.2.2 is installed, moving on."
else
  echo "--> Installing ruby-2.2.2 ..."
  su vagrant -c "mkdir -p /home/vagrant/downloads; cd /home/vagrant/downloads; \
                 wget --no-check-certificate https://ftp.ruby-lang.org/pub/ruby/ruby-2.2.2.tar.gz; \
                 tar -xvf ruby-2.2.2.tar.gz; cd ruby-2.2.2; \
                 mkdir -p /home/vagrant/ruby; \
                 ./configure --prefix=/home/vagrant/ruby --disable-install-doc; \
                 make; make install;"
  sudo -u vagrant printf 'export PATH=/home/vagrant/ruby/bin:$PATH\n' >> /home/vagrant/.profile

  su vagrant -c "echo +ruby/2.2.2 >> /home/vagrant/.provisioning-progress"
  echo "--> ruby-2.2.2 is now installed."
fi

# Install bundler
if grep -q +bundler .provisioning-progress; then
  echo "--> bundler already installed, moving on."
else
  echo "--> Installing bundler..."
  su vagrant -c "/home/vagrant/ruby/bin/gem install bundler --no-ri --no-rdoc"
  su vagrant -c "echo +bundler >> /home/vagrant/.provisioning-progress"
  echo "--> +bundler is now installed."
fi

# Install postgresql
if grep -q +postgresql .provisioning-progress; then
  echo "--> postgresql already installed, moving on."
else
  echo "--> Installing postgresql..."
  apt-get install -y postgresql
  apt-get install -y libpq-dev
  su vagrant -c "echo +postgresql  >> /home/vagrant/.provisioning-progress"
  echo "--> +postgresql is now installed."
fi

# Run bundle install in the project
echo "--> bundle install in the project"
su vagrant -c "export PATH=/home/vagrant/ruby/bin:$PATH; cd /vagrant; bundle"
echo "--> bundle install finished."

# Add vagrant user to database
PG_HBA="/etc/postgresql/9.3/main/pg_hba.conf"
if grep -q +rails_app/db_user .provisioning-progress; then
  echo "--> db user already present"
else
  echo "--> create db user"
  echo "host    all             all             all                     md5" >> "$PG_HBA"
  # Restart to load new pg_hba.conf
  service postgresql restart
  sudo -u postgres psql --command "create role vagrant with password '1111' login createdb;"
  su vagrant -c "echo +rails_app/db_user >> /home/vagrant/.provisioning-progress"
  echo "--> rails_app/db_user finished"
fi

# Create seed + sample data in database
if grep -q +rails_app/db_setup .provisioning-progress; then
  echo "--> database already setup and seeds present"
else
  echo "--> setup db + seed data"
  ln -svf /vagrant/config/database.sample.yml /vagrant/config/database.yml
  ln -svf /vagrant/.vagrant-skel/application.yml /vagrant/config/application.yml
  su vagrant -c "export PATH=/home/vagrant/ruby/bin:$PATH; cd /vagrant; bundle exec rake db:setup;"
  su vagrant -c "export PATH=/home/vagrant/ruby/bin:$PATH; cd /vagrant; bundle exec rake db:seed:company_fields;"
  su vagrant -c "export PATH=/home/vagrant/ruby/bin:$PATH; cd /vagrant; bundle exec rake db:seed:admin;"
  su vagrant -c "export PATH=/home/vagrant/ruby/bin:$PATH; cd /vagrant; bundle exec rake db:seed:employees;"
  su vagrant -c "echo +rails_app/db_setup >> /home/vagrant/.provisioning-progress"
  echo "--> +rails_app/db_setup finished."
fi

# Install redis
if grep -q +redis .provisioning-progress; then
  echo "--> redis is already installed"
else
  add-apt-repository -y ppa:chris-lea/redis-server
  apt-get update -yq
  apt-get install --no-install-suggests -yq redis-server
  su vagrant -c "echo +redis >> /home/vagrant/.provisioning-progress"
  echo "--> +redis intalling finished."
fi

# Run migrations
su vagrant -c "export PATH=/home/vagrant/ruby/bin:$PATH; cd /vagrant; bundle exec rake db:migrate;"

# Run Guard Rails and background
if [ -f /vagrant/tmp/pids/server.pid ]; then
  rm /vagrant/tmp/pids/server.pid
fi
su vagrant -c "export PATH=/home/vagrant/ruby/bin:$PATH; cd /vagrant; bundle exec foreman start;"
echo "Rails finished"
