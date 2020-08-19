source_paths.unshift(File.dirname(__FILE__))

group :development, :test do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-locally', require: false
  gem 'capistrano-rails'
  gem 'capistrano-rake'
  gem 'capistrano-rbenv'
end

run 'bundle install'

%w[example.env .env].each do |env_file|
  append_to_file env_file do
    <<~CONTENT
    APP_NAME=app
    REPO_URL=admin
  end
end

template 'Capfile'
template 'config/deploy.rb'
template 'lib/aws_helper.rb'
template 'spec/lib/aws_helper_spec.rb'
template 'config/deploy/disaster_recovery.rb'
template 'config/deploy/production.rb'
template 'config/deploy/uat.rb'

# Given that most of our Capistrano deployments go to AWS,
# include code to introspect an AWS environment and get the dynamic IPs of the app servers.

template 'lib/aws_ec2_metadata_finder.rb'
template 'spec/lib/aws_ec2_metadata_finder_spec.rb'
insert_into_file 'config/application.rb', before: /^  end/ do
  <<-'RUBY'
    require_relative "../lib/aws_ec2_metadata_finder"
  RUBY
end
