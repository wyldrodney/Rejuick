set :application, "Rejuick"


## Repository
set :repository,  "git@github.com:wyldrodney/Rejuick.git"
set :deploy_via, :remote_cache
set :scm, :git
set :scm_username, "wyldrodney"
set :ssh_options, {:forward_agent => true}


## Server
server "localhost", :app, :web, :db, :primary => true
set :deploy_to, "/tmp/rejuick-project"
set :user, "root"
default_run_options[:pty] = true


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
