# Rails Template

## Origins

This repo is forked from mattbrictson/rails-template, and has been customized to
set up Rails projects the way Ackama likes them.
Many thanks to @joshmcarthur and @mattbrictson upon whose work we have built.

## Description

This is the application template that we use for Rails 6 projects. As a
fabulous consultancy, we need to be able to start new projects quickly and
with a good set of defaults.

For older versions of Rails, use these branches of @mattbrictson's original repository:

- [Rails 4.2.x](https://github.com/mattbrictson/rails-template/tree/rails-42)
- [Rails 5.0.x](https://github.com/mattbrictson/rails-template/tree/rails-50)
- [Rails 5.1.x](https://github.com/mattbrictson/rails-template/tree/rails-51)
- [Rails 5.2.x](https://github.com/mattbrictson/rails-template/tree/rails-52)

## Requirements

- Yarn: Some old versions of Yarn have encountered issues, if you have problems try v1.21.0 or later

This template currently works with:

- Rails 6.0.x
- PostgreSQL
- chromedriver

If you are using Windows Subsystem for Linux (WSL) and using Windows
applications to work with code (rather than working entirely in WSL), you may
wish to set an environment variable named `SKIP_INSTALLING_OVERCOMMIT_IN_SETUP`
to `true` when generating the template (e.g.
`SKIP_INSTALLING_OVERCOMMIT_IN_SETUP=true rails new ...`). This will prevent git
hooks from being installed that normally run linting and other checks when
committing. These checks can fail to bridge between Windows and WSL and
interfere with the development workflow. We otherwise recommend installing
overcommit.

## Usage

This template assumes you will store your project in a remote git repository
(e.g. Bitbucket or GitHub) and that you will deploy to a production environment.
It will prompt you for this information in order to pre-configure your app, so
be ready to provide:

1. The git URL of your (freshly created and empty) Bitbucket/GitHub repository
2. The hostname of your production server

To generate a Rails application using this template, pass the `--template` option to
`rails new`, like this:

```
rails new blog \
  --no-rc \
  --database=postgresql \
  --template=https://raw.githubusercontent.com/ackama/rails-template/main/template.rb
```

_Remember that options must go after the name of the application._ The only
database supported by this template is `postgresql`.

Here are some additional options you can add to this command. We don't _prescribe_ these,
but you may find that many Ackama projects are started with some or all of these options:

* `--skip-action-mailbox` skips the setup of ActionMailbox, which you don't need unless you are receiving emails in your application.
* `--skip-active-storage` skips the setup of ActiveStorage. If you don't need support for file attachments, this can be skipped.
* `--skip-spring` - you _probably_ want to use this. Spring is great at reducing the start time of Rails processes once
  one is already running, but also tends to cache things more than it should and mask issues (or worse, issues being resolved). We have found that Bootsnap, which is also generated by default takes care of a decent startup time optimisation without the drawbacks of spring.
* `--skip-action-cable` - if you're not doing things with websockets, you may want to consider skipping this one to avoid
  having an open websocket connection without knowing about it.
* `--skip-turbolinks` - in a similar vein to spring, Turbolinks is great and providing some user feedback as pages load
  and speeding up perceived load time, however comes with drawbacks that usually outweight the benefits.
* `--webpack=react` - this will preconfigure your app to build and serve React code. You only need it if you're going
  to be using React, but adding this during app generation will mean that your codebase supports webpack and React
  components right from the first commit.

If you just want to see what the template does, try running `docker build .` and
then `docker --rm -it run` the resulting image. You'll be dropped into Bash and
can explore the generated app in `/apps/template-test`. The image doesn't
include PostgreSQL right now, so database operations don't work.

## Installation (Optional)

If you find yourself generating a lot of Rails applications, you
can load default options into a file in your home directory named `.railsrc`, and
these options will be applied as arguments each time you run `rails new`
(unless you pass the `--no-rc` option).

To make this the default Rails application template on your system, create a
`~/.railsrc` file with these contents:

```
-d postgresql
-m https://raw.githubusercontent.com/ackama/rails-template/main/template.rb
```

Once you’ve installed this template as your default, then all you have to do is run:

```
rails new --database=postgresql blog
```

## What does it do?

The template will perform the following steps:

1. Generate your application files and directories
2. Ensure bundler is installed
3. Create the development and test databases
4. Commit everything to git
5. Push the project to the remote git repository you specified


#### Other tweaks that patch over some Rails shortcomings

- A much-improved `bin/setup` script

## How does it work?

This project works by hooking into the standard Rails [application templates](https://guides.rubyonrails.org/rails_application_templates.html)
system, with some caveats. The entry point is the [template.rb](https://github.com/ackama/rails-template/blob/main/template.rb) file in the
root of this repository.

Normally, Rails only allows a single file to be specified as an application
template (i.e. using the `-m <URL>` option). To work around this limitation, the
first step this template performs is a `git clone` of the
`ackama/rails-template` repository to a local temporary directory.

This temporary directory is then added to the `source_paths` of the Rails
generator system, allowing all of its ERb templates and files to be referenced
when the application template script is evaluated.

Rails generators are very lightly documented; what you’ll find is that most of the heavy lifting is done by  [Thor](http://whatisthor.com/). Thor is a tool that allows you to easily perform command line utilities.  The most common methods used by this template are Thor’s `copy_file`, `template`, and `gsub_file`. You can dig into the well-organized and well-documented [Thor source code](https://github.com/erikhuda/thor) to learn more.
If any file finishes with `.tt`, Thor considers it to be a template and places it in the destination without the extension `.tt`.

## Tooling choices and configuration

#### Testing: [webdrivers](https://github.com/titusfortner/webdrivers)
auto-installs headless Chrome

#### ENV managment: [dotenv](https://github.com/bkeepers/dotenv)
in place of the Rails `secrets.yml`

#### Application web server: [puma](https://github.com/puma/puma)

#### Security Auditing: [brakeman](https://github.com/presidentbeef/brakeman) and [bundler-audit](https://github.com/rubysec/bundler-audit)

#### Editor code style settings: [EditorConfig](https://editorconfig.org/)
“EditorConfig helps maintain consistent coding styles for multiple developers working on the same project across various editors and IDEs. The EditorConfig project consists of a file format for defining coding styles and a collection of text editor plugins that enable editors to read the file format and adhere to defined styles. EditorConfig files are easily readable and they work nicely with version control systems”

See the `editorconfig` file for Ackama’s styles

#### Git hook manager: [Overcommit](https://github.com/sds/overcommit)
Git has a way to fire off custom scripts when certain important actions occur, by using [Git hooks ](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)

Overcommit is a tool to manage and configure Git hooks

Edit `overcommit.yml` to configure the Overcommit hooks you wish to use

#### Code coverage measurement: [Simplecov](https://github.com/simplecov-ruby/simplecov)
Code coverage is a measurement of how many lines/blocks/arcs of your code are executed while the automated tests are running.

SimpleCov is a code coverage analysis tool for Ruby. It provides an API to filter, group, merge, format, and display the results

#### JS package manager: [Yarn](https://yarnpkg.com/)
“Yarn is a package manager for your code”. Think of it as Bundler for JavaScript. Yarn uses a file similar to Bundler’s Gemfile called `package.json`, found in the Rails root directory.

#### Code linting and formatting
Linting is the automated checking of your source code for programmatic and stylistic errors. Check the docs of each linter for how to automatically format code.

- JS/HTML/CSS:  [Prettier](https://prettier.io/), Set up with  an [Ackama prettier config](https://github.com/ackama/prettier-config-ackama) and a variety of other prettier plugins, see the full list in `variants/frontend-base/template.rb`

- JavaScript: [ESlint](https://eslint.org/), Ackama uses the rules found at [eslint-config-ackama](https://github.com/ackama/eslint-config-ackama)
Styles: [stylelint](https://github.com/stylelint/stylelint)

- Ruby: [Rubocop](https://github.com/rubocop-hq/rubocop), with [ackama rubocop settings](https://bitbucket.org/rabidtech/rabid-dotfiles/raw/master/.rubocop.yml)

- Editor code style settings: [EditorConfig](https://editorconfig.org/),
“EditorConfig helps maintain consistent coding styles for multiple developers working on the same project across various editors and IDEs. The EditorConfig project consists of a file format for defining coding styles and a collection of text editor plugins that enable editors to read the file format and adhere to defined styles. EditorConfig files are easily readable and they work nicely with version control systems”. See the `editorconfig` file for Ackama’s styles.

## Variants
We consider variants as variations on the default rails app generated by `rails new`

In the medium-to-long term, we intend to move as much of the template code into the 'variants' folder as possible.

We aim to have the variants run as part of a configuration file, so that the rails-template becomes a metapackage where the template simply applies an "ackama-core" variant.
After that, all the opt-in variants will get applied in some kind of configuration step.

Each subdirectory of the variant directory contains a template.rb file, which is used to customize the newly generated app. Each `template.rb` tends to be well commented, and acts as the variant’s documentation.

### Default Variants

#### accessibility
"Web accessibility is the inclusive practice of ensuring there are no barriers that prevent interaction with, or access to, websites on the World Wide Web by people with physical disabilities, situational disabilities, and socio-economic restrictions on bandwidth and speed. When sites are correctly designed, developed and edited, generally all users have equal access to information and functionality." https://en.wikipedia.org/wiki/Web_accessibility

This variant sets up automated accessibility testing. We use the combination of [axe](https://www.deque.com/axe/) and [lighthouse](https://developers.google.com/web/tools/lighthouse) to provide comprehensive coverage.

Axe Matchers is a gem that provides cucumber steps and rspec matchers that will check the accessibility compliance of your views. We require a default standard of wcag2a and wcag2aa. We recommend that your tests all live in a `spec/features/accessibility`, to allow for running them separately. Using the shared examples found at `variants/accessibility/spec/support/shared_examples/an_accessible_page.rb` for your base tests avoids duplication and misconfiguration.

Ackama maintains [lighthouse matchers](https://github.com/ackama/lighthouse-matchers) which provide RSpec matchers to assess the accessibility compliance of your application. We recommend setting your passing score threshold to 100 for new projects. As with Axe, you can keep your test suite tidy by placing these tests in `spec/features/accessibility`.

#### frontend-base
- renames `app/javascript` to `app/frontend`, a directory containing the webpacker configuration. This allows you to place stylesheets in `app/frontend/stylesheets/`, and images in `app/frontend/images` Rails 6 has added [Webpacker](https://github.com/rails/webpacker) as the default JavaScript compiler instead of Sprockets. Thus, all JS code is compiled with the help of [webpack](https://webpack.js.org/) by default
- Initializes [sentry](https://sentry.io/welcome/) error reporting
- Initializes Ackama’s linting and code formatting settings, see [Code linting and formatting](#code-linting-and-formatting)

#### performance
Add configuration and specs to use to perform a [lighthouse performance](https://web.dev/performance-scoring/) audit, requiring a score of at least 95.

#### bullet
Add configuration to use to prevent N+1 queries, see  [bullet](https://github.com/flyerhzm/bullet)

### Optional Variants

#### devise
Authentication refers to verifying identity. A failed authentication results in the status code `401 unauthorized`.

[Devise](https://github.com/heartcombo/devise) is a rack based, complete MVC authentication solution based on Rails engines.
It's composed of 10 optional modules.

The relevant config files are found in `rails-template/variants/devise`.
`variants/devise/template.rb` contains comments on Ackama’s custom setup choices.

Noteabley, these files generate a User model with devise `:validatable` and `:lockable`, and add Ackama preferences in the `devise.rb` initialiser file

#### frontend-react
adds configuration, example of react, which is based on [rails-react](https://github.com/reactjs/react-rails)

The relevant config files are found in `variants/frontend-react`

#### sidekiq
A job scheduler is a computer application for controlling unattended background program execution of jobs

Note that the non enterprise version of [Sidekiq](https://github.com/mperham/sidekiq) doesn't do scheduling by default, it only executes jobs









