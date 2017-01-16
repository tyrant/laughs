# config valid only for current version of Capistrano
lock "3.7.1"

set :application, "laughs"
set :repo_url, "git@github.com:tyrant/laughs.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/app-user/laughs"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :user, 'app-user'
set :deploy_via, 'remote-copy'

# http://stackoverflow.com/questions/34126546
set :rbenv_path, '/home/app-user/.rbenv'

# If you are using rbenv add these lines:
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.2'

namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc "Make a secrets.yml symlink"
  task :copy_secrets do
    on roles(:app), in: :sequence, wait: 5 do
      # Capistrano already makes a symlink to database.yml in the /shared/config directory; Rails
      # requires secrets.yml too.
      execute 'ln ~/laughs/shared/config/secrets.yml ~/laughs/current/config/secrets.yml'
    end
  end

  after :publishing, 'deploy:restart'
  #after :publishing, 'deploy:copy_secrets'
  after :finishing, 'deploy:cleanup'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end