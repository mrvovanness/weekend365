# Generated by babushka-0.18.2 at 2015-08-10 19:22:55 +0500, from adb5f3cd9e5a1d5efebc002c66a3c77b4c9a6362. 86047afd6a5e2bd6783d3aff7958a19a9041e487 
# !!!config valid only for Capistrano 3.1!!!
#lock '3.1.0'

set :application, "weeekend365"
set :repo_url, "git@bitbucket.org:team-kadore/sss.git"

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, "/opt/#{fetch(:application)}"
set :scm, :git
set :ssh_options, :forward_agent => true
set :rails_env, "production"

# set :format, :pretty
# set :log_level, :debug
# set :pty, true
# set :user, "root"
# set :use_sudo, false

set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/sockets}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

# ----- RVM ----------
set :rvm_type, :system
set :rvm_ruby_version, '2.2.2'

# - for unicorn - #
namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      execute "cd #{current_path} && bundle exec foreman export initscript /etc/init.d " +
      "-f ./Procfile.production -a #{fetch(:application)} -u #{fetch(:user)} -l #{shared_path}/log"
      execute "chmod 755 /etc/init.d/#{fetch(:application)}"
    end
  end

  desc "Start the application services"
  task :start do
    on roles(:app) do
      execute "/etc/init.d/#{fetch(:application)} start"
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles(:app) do
      execute "/etc/init.d/#{fetch(:application)} stop"
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles(:app) do
      execute "/etc/init.d/#{fetch(:application)} stop; /etc/init.d/#{fetch(:application)} start"
    end
  end

  desc "Display logs for a certain process - arg example: PROCESS=web-1"
  task :logs do
    on roles(:app) do
      execute "cd #{current_path}/log && cat #{ENV["PROCESS"]}.log"
    end
  end
end

# deploy with foreman#
#
namespace :deploy do

  after :publishing, 'foreman:export'
  after :publishing, :restart
  after :finishing, 'deploy:cleanup'
  
  desc "Zero-downtime restart of Unicorn"
  task :restart do
    invoke 'foreman:restart'
  end

  desc "Start unicorn"
  task :start do
    invoke 'foreman:start'
  end

  desc "Stop unicorn"
  task :stop do
    invoke 'foreman:stop'
  end
end

