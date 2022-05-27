# Ackama Rails Template

This is the application template that we use for new Rails projects. As a fabulous
consultancy, we need to be able to start new projects quickly and with a good
set of defaults.

## Origins

This repo is forked from
[mattbrictson/rails-template](https://github.com/mattbrictson/rails-template),
and has been customized to set up Rails projects the way Ackama likes them. Many
thanks to [@joshmcarthur](https://github.com/joshmcarthur) and
[@mattbrictson](https://github.com/mattbrictson) upon whose work we have built.

## Requirements

- Yarn: Some old versions of Yarn have encountered issues, if you have problems
  try v1.21.0 or later

This template currently works with:

- Rails 7.0.x
- PostgreSQL
- chromedriver

## Usage

This template requires a YAML configuration file to to configure options.

It will use `ackama_rails_template.config.yml` in your current working directory
if it exists. Otherwise you can specify a path using the `CONFIG_PATH`
environment variable.

[ackama_rails_template.config.yml](./ackama_rails_template.config.yml) is a
documented configuration example that you can copy.

To generate a Rails application using this template, pass the `--template`
option to `rails new`, like this:

```bash
# template options will be taken from ./ackama_rails_template.config.yml
$ rails new my_app --no-rc --database=postgresql --skip-javascript --template=https://raw.githubusercontent.com/ackama/rails-template/main/template.rb

# template options will be taken from from your custom config file
$ CONFIG_PATH=./my_custom_config.yml rails new my_app --no-rc --database=postgresql --skip-javascript --template=https://raw.githubusercontent.com/ackama/rails-template/main/template.rb
```

The only database supported by this template is `postgresql`.

Here are some additional options you can add to this command. We don't _prescribe_ these,
but you may find that many Ackama projects are started with some or all of these options:

* `--skip-javascript` skips the setup of JavaScript imports/compilers, Rails 7.0.x is no longer automatically includes [Webpacker](https://github.com/rails/webpacker), instead it uses [Importmap](https://github.com/rails/importmap-rails) by default.
* `--skip-action-mailbox` skips the setup of ActionMailbox, which you don't need unless you are receiving emails in your application.
* `--skip-active-storage` skips the setup of ActiveStorage. If you don't need support for file attachments, this can be skipped.
* `--skip-action-cable` - if you're not doing things with websockets, you may want to consider skipping this one to avoid
  having an open websocket connection without knowing about it.
* `--webpack=react` - this will preconfigure your app to build and serve React code. You only need it if you're going
  to be using React, but adding this during app generation will mean that your codebase supports webpack and React
  components right from the first commit.

## Installation (Optional)

If you find yourself generating a lot of Rails applications, you can load
default options into a file in your home directory named `.railsrc`, and these
options will be applied as arguments each time you run `rails new` (unless you
pass the `--no-rc` option).

To make this the default Rails application template on your system, create a
`~/.railsrc` file with these contents:

```
# ~/.railsrc
-d postgresql
-m https://raw.githubusercontent.com/ackama/rails-template/main/template.rb
```

Once you've installed this template as your default, then all you have to do is
run:

```bash
$ rails new my-awesome-app
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

## Tooling choices and configuration

#### Testing: [webdrivers](https://github.com/titusfortner/webdrivers)

auto-installs headless Chrome

#### ENV managment: [dotenv](https://github.com/bkeepers/dotenv)

in place of the Rails `secrets.yml`

#### Application web server: [puma](https://github.com/puma/puma)

#### Security Auditing: [brakeman](https://github.com/presidentbeef/brakeman) and [bundler-audit](https://github.com/rubysec/bundler-audit)

#### Editor code style settings: [EditorConfig](https://editorconfig.org/)

> EditorConfig helps maintain consistent coding styles for multiple developers
> working on the same project across various editors and IDEs. The EditorConfig
> project consists of a file format for defining coding styles and a collection of
> text editor plugins that enable editors to read the file format and adhere to
> defined styles. EditorConfig files are easily readable and they work nicely with
> version control systems

See the [.editorconfig](./editorconfig) file for Ackama's styles

#### Git hook manager: [Overcommit](https://github.com/sds/overcommit)

Git has a way to fire off custom scripts when certain important actions occur,
by using [Git hooks ](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)

Overcommit is a tool to manage and configure Git hooks

Edit `overcommit.yml` to configure the Overcommit hooks you wish to use

#### Code coverage measurement: [Simplecov](https://github.com/simplecov-ruby/simplecov)

Code coverage is a measurement of how many lines/blocks/arcs of your code are
executed while the automated tests are running.

SimpleCov is a code coverage analysis tool for Ruby. It provides an API to
filter, group, merge, format, and display the results

#### JS package manager: [Yarn](https://yarnpkg.com/)

> Yarn is a package manager for your code.

Think of it as Bundler for
JavaScript. Yarn uses a file similar to Bundler's Gemfile called `package.json`,
found in the Rails root directory.

#### Code linting and formatting

Linting is the automated checking of your source code for programmatic and
stylistic errors. Check the docs of each linter for how to automatically format
code.

- JS/HTML/CSS: [Prettier](https://prettier.io/), Set up with an
  [Ackama prettier config](https://github.com/ackama/prettier-config-ackama) and
  a variety of other prettier plugins, see the full list in
  `variants/frontend-base/template.rb`

- JavaScript: [ESlint](https://eslint.org/), Ackama uses the rules found at
  [eslint-config-ackama](https://github.com/ackama/eslint-config-ackama) Styles:
  [stylelint](https://github.com/stylelint/stylelint)

- Ruby: [Rubocop](https://github.com/rubocop-hq/rubocop), with
  [ackama rubocop settings](https://bitbucket.org/rabidtech/rabid-dotfiles/raw/master/.rubocop.yml)

- Editor code style settings: [EditorConfig](https://editorconfig.org/),
  > EditorConfig helps maintain consistent coding styles for multiple developers
  > working on the same project across various editors and IDEs. The EditorConfig
  > project consists of a file format for defining coding styles and a collection
  > of text editor plugins that enable editors to read the file format and adhere
  > to defined styles. EditorConfig files are easily readable and they work nicely
  > with version control systems". See the `editorconfig` file for Ackama's
  > styles.

## Variants

We consider variants as variations on the default rails app generated by
`rails new`

In the medium-to-long term, we intend to move as much of the template code into
the 'variants' folder as possible.

We aim to have the variants run as part of a configuration file, so that the
rails-template becomes a metapackage where the template simply applies an
"ackama-core" variant. After that, all the opt-in variants will get applied in
some kind of configuration step.

Each subdirectory of the variant directory contains a template.rb file, which is
used to customize the newly generated app. Each `template.rb` tends to be well
commented, and acts as the variant's documentation.

### Default Variants

#### accessibility

"Web accessibility is the inclusive practice of ensuring there are no barriers
that prevent interaction with, or access to, websites on the World Wide Web by
people with physical disabilities, situational disabilities, and socio-economic
restrictions on bandwidth and speed. When sites are correctly designed,
developed and edited, generally all users have equal access to information and
functionality." https://en.wikipedia.org/wiki/Web_accessibility

This variant sets up automated accessibility testing. We use the combination of
[axe](https://www.deque.com/axe/) and
[lighthouse](https://developers.google.com/web/tools/lighthouse) to provide
comprehensive coverage.

Axe Matchers is a gem that provides cucumber steps and rspec matchers that will
check the accessibility compliance of your views. We require a default standard
of wcag2a and wcag2aa. We recommend that your tests all live in a
`spec/features/accessibility`, to allow for running them separately. Using the
shared examples found at
`variants/accessibility/spec/support/shared_examples/an_accessible_page.rb` for
your base tests avoids duplication and misconfiguration.

Ackama maintains
[lighthouse matchers](https://github.com/ackama/lighthouse-matchers) which
provide RSpec matchers to assess the accessibility compliance of your
application. We recommend setting your passing score threshold to 100 for new
projects. As with Axe, you can keep your test suite tidy by placing these tests
in `spec/features/accessibility`.

#### frontend-base

- renames `app/javascript` to `app/frontend`, a directory containing the
  webpacker configuration. This allows you to place stylesheets in
  `app/frontend/stylesheets/`, and images in `app/frontend/images` Rails 6 has
  added [Webpacker](https://github.com/rails/webpacker) as the default
  JavaScript compiler instead of Sprockets. Thus, all JS code is compiled with
  the help of [webpack](https://webpack.js.org/) by default
- Initializes [sentry](https://sentry.io/welcome/) error reporting
- Initializes Ackama's linting and code formatting settings, see
  [Code linting and formatting](#code-linting-and-formatting)

#### performance

Add configuration and specs to use to perform a
[lighthouse performance](https://web.dev/performance-scoring/) audit, requiring
a score of at least 95.

#### bullet

Add configuration to use to prevent N+1 queries, see
[bullet](https://github.com/flyerhzm/bullet)

### Optional Variants

#### devise

Authentication refers to verifying identity. A failed authentication results in
the status code `401 unauthorized`.

[Devise](https://github.com/heartcombo/devise) is a rack based, complete MVC
authentication solution based on Rails engines. It's composed of 10 optional
modules.

The relevant config files are found in `rails-template/variants/devise`.
`variants/devise/template.rb` contains comments on Ackama’s custom setup
choices.

Noteably, these files generate a User model with devise `:validatable` and
`:lockable`, and add Ackama preferences in the `devise.rb` initialiser file

#### frontend-bootstrap

Adds
[Bootstrap](https://getbootstrap.com/docs/5.0/getting-started/introduction/) for
theming and core component styles. This selection was made due to the breadth
of existing styles this provides which enables us to create consistent and great
looking web pages reasonably quickly.

A key benefit of Bootstrap is that it allows easy customization. Bootstrap is
modular and consists of Sass stylesheets that implement various components of
the toolkit. Developers select components and make global adjustments
through a central configuration stylesheet.

The disadvantage is that bootstrap is relatively big, and if we send too muchCSS
to the browser it slows down the app. One way we mitigate this is by trying to
rely whenever reasonable on Bootstrap variables and utility classes. The
principles which determine this are:

1. Look and see if there is a default
   [Bootstrap component](https://getbootstrap.com/docs/5.0/components/) that
   meets the use case.
2. Look at the
   [Bootstrap variables](https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss)
   to see if there is an appropriate customisation, keeping in mind this will
   impact all instances which rely on that variable within the app
3. Look at the
   [Bootstrap utilities](https://getbootstrap.com/docs/5.0/utilities/api/) for
   modifications which would allow using existing styles
4. If there's not a bootstrap component for what you require, only create a new
   component in `app/frontend/stylesheets/components` if there are at least 3
   occurrences of a group of styles, or it is a very distinct set of styles
5. Once a component exists, modifications are achieved with utility classes
   unless there are at least 3 occurrences where all the same modifications are
   being applied

#### frontend-react
adds configuration, example of react, which is based on [rails-react](https://github.com/reactjs/react-rails)

The relevant config files are found in `variants/frontend-react`.

An example react test using [react-testing-library](https://testing-library.com/docs/react-testing-library/intro/) is provided. Before you start adding more tests, it is recommended you read [common-mistakes-with-react-testing-library](https://kentcdodds.com/blog/common-mistakes-with-react-testing-library)

#### sidekiq

A job scheduler is a computer application for controlling unattended background
program execution of jobs

Note that the non enterprise version of
[Sidekiq](https://github.com/mperham/sidekiq) doesn't do scheduling by default,
it only executes jobs


## Setup for contributing to this template

```bash
# create new rails app in tmp/builds/enterprise using ci/configs/react.yml as configuration
CONFIG_PATH="ci/configs/react.yml" APP_NAME="enterprise" ./ci/bin/build-and-test

# or do it manually:
#
# CONFIG_PATH must be relative to the dir that the rails app is created in
# because the template is run by `rails new` which uses the rails app dir as
# it's working dir, hence the `../` at the start.
#
rm -rf mydemoapp && CONFIG_PATH="../ci/configs/react.yml" rails new mydemoapp -d postgresql --skip-javascript -m ./template.rb
```

The relevant config files are found in `variants/frontend-react`

## How does this template work?

This project works by hooking into the standard Rails
[application templates](https://guides.rubyonrails.org/rails_application_templates.html)
system, with some caveats. The entry point is the
[template.rb](https://github.com/ackama/rails-template/blob/main/template.rb)
file in the root of this repository.

Normally, Rails only allows a single file to be specified as an application
template (i.e. using the `-m <URL>` option). To work around this limitation, the
first step this template performs is a `git clone` of the
`ackama/rails-template` repository to a local temporary directory.

This temporary directory is then added to the `source_paths` of the Rails
generator system, allowing all of its ERb templates and files to be referenced
when the application template script is evaluated.

Rails generators are very lightly documented; what you'll find is that most of
the heavy lifting is done by [Thor](http://whatisthor.com/). Thor is a tool that
allows you to easily perform command line utilities. The most common methods
used by this template are Thor's `copy_file`, `template`, and `gsub_file`. You
can dig into the well-organized and well-documented
[Thor source code](https://github.com/erikhuda/thor) to learn more. If any file
finishes with `.tt`, Thor considers it to be a template and places it in the
destination without the extension `.tt`.
