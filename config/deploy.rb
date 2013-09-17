require 'bundler/capistrano'

set :application, "livetocode"
set :repository,  "git://github.com/shevaun/enki.git"
set :scm, :git

#RVM bootstrap
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3-p448'
set :branch, 'livetocode'
set :rvm_type, :system
set :rvm_path, "/usr/local/rvm"

server 'alpha.livetocode.co.nz', :app, :web, :db, primary: true
set :user, "deploy"
set :deploy_to, "/var/apps/livetocode"
set :use_sudo, false

require 'capistrano/shared_file'
set :shared_files, %w(.env config/database.yml)

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

before 'deploy:assets:precompile', 'deploy:symlink_database_file'

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
