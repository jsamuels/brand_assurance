set :application, "VCC"
set :repository,  "git@github.com:itchy/VCC.git"





# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, "git"
set :scm_passphrase, "bubba3927" #This is your custom users password


# this needs to be changed....
set :user, "deployer"
ssh_options[:forward_agent] = true
set :branch, "master"

role :app, "your app-server here"
role :web, "your web-server here"
role :db,  "your db-server here", :primary => true