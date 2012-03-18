require 'bundler/capistrano'

set :application, "livetocode"
set :repository,  "git://github.com/shevaun/enki.git"
set :scm, :git

#RVM bootstrap
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3-p125'
set :branch, 'livetocode'

server 'alpha.livetocode.co.nz', :app, :web, :db, primary: true
set :user, "deploy"
set :deploy_to, "/var/apps/livetocode"
set :use_sudo, false

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "symlink database file"
  task :symlink_database_file, :roles => :app do
    run "ln -s /var/apps/livetocode/shared/database.yml #{release_path}/config/database.yml"
  end
end

before 'deploy:assets:precompile', 'deploy:symlink_database_file'
