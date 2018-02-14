# Rails Template

## Origins

This repo is forked from mattbrictson/rails-template, and has been customized to set up Rails projects the way I like them.

## Description

This is the application template that I use for my Rails 5.0 projects. As a  Rails developer, I need to be able to start new projects quickly and with a good set of defaults. I've tweaked this template over the years to include best-practices, documentation, and personal preferences, while still generally adhering to the "Rails way".

## Requirements

This template currently works with:

* Rails 4.0.x
* PostgreSQL

## Installation

*Optional.*

To make this the default Rails application template on your system, create a `~/.railsrc` file with these contents:

```
-d postgresql
-m https://raw.githubusercontent.com/joshmcarthur/rails-template/master/template.rb
```

## Usage

This template assumes you will store your project in a remote git repository (e.g. Bitbucket or GitHub). It will prompt you for this information in order to pre-configure your app, so be ready to provide:

1. The git URL of your (freshly created and empty) Bitbucket/GitHub repository
2. The hostname of your staging server
3. The hostname of your production server

To generate a Rails application using this template, pass the `-m` option to `rails new`, like this:

```
rails new blog \
  -d postgresql \
  -m https://raw.githubusercontent.com/joshmcarthur/rails-template/master/template.rb
```

*Remember that options must go after the name of the application.* The only database supported by this template is `postgresql`.

If you’ve installed this template as your default (using `~/.railsrc` as described above), then all you have to do is run:

```
rails new blog
```

If you just want to see what the template does, try running `docker build .` and then `docker --rm -it run` the resulting image. You'll be dropped into Bash and can explore the generated app in `/apps/template-test`. The image doesn't include PostgreSQL right now, so database operations don't work.

## What does it do?

The template will perform the following steps:

1. Generate your application files and directories
2. Ensure bundler is installed
3. Create the development and test databases
4. Commit everything to git
5. Check out a `development` branch
6. Push the project to the remote git repository you specified

## What is included?

#### These gems are added to the standard Rails stack

* `dotenv-rails` - loads environment variables from `.env` and `.env.#{RAILS_ENV}`. 
* `secure_headers` - sets CSP headers and a bunch of other headers to harden your app against XSS attacks
* `simplecov` - code coverage reports
* `letter_opener` - open emails in your web browser in development and test
* RSpec, FactoryBot, Capybara, and Poltergeist - my current testing stack, though this might branch off into a test::unit option.
* `unicorn` – the industry-standard Rails server


#### Mandrill SMTP

Action Mailer is configured to use [Mandrill][] for SMTP. You can change this by editing `environments/production.rb`.

#### Bootstrap integration (optional)

[Bootstrap][]-related features are opt-in. To apply these to your project, answer "yes" when prompted.

* Bootstrap-themed scaffold templates
* Application layout that includes Bootstrap-style navbar and boilerplate
* View helpers for generating common Bootstrap markup

#### Other tweaks that patch over some Rails shortcomings

* A much-improved `bin/setup` script

#### Plus lots of documentation for your project

* `README.md`
* `PROVISIONING.md`
* `DEPLOYMENT.md`

## How does it work?

This project works by hooking into the standard Rails [application templates][] system, with some caveats. The entry point is the [template.rb][] file in the root of this repository.

Normally, Rails only allows a single file to be specified as an application template (i.e. using the `-m <URL>` option). To work around this limitation, the first step this template performs is a `git clone` of the `joshmcarthur/rails-template` repository to a local temporary directory.

This temporary directory is then added to the `source_paths` of the Rails generator system, allowing all of its ERb templates and files to be referenced when the application template script is evaluated.

Rails generators are very lightly documented; what you’ll find is that most of the heavy lifting is done by [Thor][]. The most common methods used by this template are Thor’s `copy_file`, `template`, and `gsub_file`. You can dig into the well-organized and well-documented [Thor source code][thor] to learn more.

