require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/puma'
require 'mina/bundler'


server = ENV['server'] || 'staging'

if server == 'staging'
  ip = '54.245.247.194'
  env = 'staging'
  branch_name = ENV['branch'] || 'main'
elsif server == 'preproduction'
  # ip = '34.216.130.68'
  env = 'preproduction'
  branch_name = 'prep'
elsif server == 'production'
  ip = '13.51.11.204'
  env = 'production'
  branch_name = 'main'
end

set :application_name, 'eventible-backend'
set :rvm_use_path, '/usr/local/rvm/scripts/rvm'
# set :rbenv_use_path, '/usr/local/rbenv/bin/rbenv'
set :user, 'ubuntu'
set :domain, ip
set :deploy_to, '/www/eventible-backend'
set :repository, 'git@github.com:aman-pardeshi/russian-evisa-backend.git'
set :branch, branch_name
set :rails_env, env
set :forward_agent, true

set :shared_dirs, fetch(:shared_dirs, []).push('public/assets', 'tmp/pids', 'tmp/sockets')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/master.key', 'config/secrets.yml', 'config/storage.yml', 'config/puma.rb', '.env', 'config/audited.yml')

# task :remote_environment do
#   invoke :'rbenv:load'
# end

task :setup do
  command %[touch "#{fetch(:shared_path)}/config/master.key"]
  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[touch "#{fetch(:shared_path)}/config/audited.yml"]
  command %[touch "#{fetch(:shared_path)}/config/secrets.yml"]
  command %[touch "#{fetch(:shared_path)}/config/storage.yml"]
  command %[touch "#{fetch(:shared_path)}/config/puma.rb"]
  command %[touch "#{fetch(:shared_path)}/tmp/pids/sidekiq.pid"]
  comment "Be sure to edit '#{fetch(:shared_path)}/config/database.yml', 'secrets.yml' and puma.rb."
  command %[touch "#{fetch(:shared_path)}/.env"]
end

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'deploy:cleanup'
    command "cd #{fetch(:deploy_to)}/current && bundle exec whenever -w -s environment=#{fetch(:rails_env)}"

    on :launch do
      invoke :'puma:phased_restart'
      in_path(fetch(:current_path)) do
        command %{sudo monit restart sidekiq}
      end
    end
  end
end
