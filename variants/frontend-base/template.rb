require "json"

source_paths.unshift(File.dirname(__FILE__))

# Configure app/assets

remove_file "app/assets/config/manifest.js"
create_file "app/assets/config/manifest.js" do
  <<~EO_CONTENT
  // This file must exist for assets pipeline compatibility.
  EO_CONTENT
end
remove_dir "app/assets/stylesheets"
remove_dir "app/assets/images"

# Configure app/frontend

run "mv app/javascript app/frontend"
gsub_file "config/webpacker.yml", "source_path: app/javascript", "source_path: app/frontend", force: true
empty_directory_with_keep_file "app/frontend/images"
copy_file "app/frontend/stylesheets/application.scss"
copy_file "app/frontend/stylesheets/_elements.scss"
append_to_file "app/frontend/packs/application.js" do
  <<~EO_CONTENT

  import '../stylesheets/application.scss';
  EO_CONTENT
end

enable_imgs_src = <<~EO_SRC
  //
  // const images = require.context('../images', true)
  // const imagePath = (name) => images(name, true)
EO_SRC
enable_imgs_replacement = <<~EO_REPLACEMENT

  const images = require.context('../images', true);
  // eslint-disable-next-line no-unused-vars
  const imagePath = name => images(name, true);
EO_REPLACEMENT
gsub_file "app/frontend/packs/application.js", enable_imgs_src, enable_imgs_replacement

# Configure app/views
gsub_file "app/views/layouts/application.html.erb",
          "<%= stylesheet_link_tag(",
          "<%= stylesheet_pack_tag(",
          force: true

body_open_tag_with_img_example = <<~EO_IMG_EXAMPLE
  <body>

      <%
        # An example of how to load an image via Webpacker. This image is in
        # app/frontend/images/example.png
      %>
      <%# image_pack_tag "example.png", alt: "Example Image" %>
EO_IMG_EXAMPLE
gsub_file "app/views/layouts/application.html.erb", "<body>", body_open_tag_with_img_example, force: true

# Setup Sentry
# ############

run "yarn add @sentry/browser"
run "yarn add dotenv-webpack -D"

gsub_file "config/webpack/environment.js",
  "module.exports = environment",
  <<~'EO_JS'
    const Dotenv = require('dotenv-webpack');

    environment.plugins.prepend('Dotenv', new Dotenv());

    module.exports = environment;
  EO_JS

append_to_file "app/frontend/packs/application.js" do
  <<~'EO_JS'

    // Initialize Sentry Error Reporting
    //
    // Import all your application's JS after this section because we need Sentry
    // to be initialized **before** we import any of our actual JS so that Sentry
    // can report errors from it.
    //
    import * as Sentry from '@sentry/browser';
    Sentry.init({ dsn: process.env.SENTRY_DSN });

    // Uncomment this Sentry by sending an exception every time the page loads.
    // Obviously this is a very noisy activity and we do have limits on Sentry so
    // you should never do this on a deployed environment.
    //
    // Sentry.captureException(new Error('Away-team to Enterprise, two to beam directly to sick bay...'));

    // Import all your application's JS here
    //
    // import '../javascript/example-1.js';
    // import { someFunc } from '../javascript/funcs.js';
  EO_JS
end

# Javascript code linting and formatting
# ######################################

run "rm .browserslistrc"
run "yarn add --dev eslint eslint-plugin-prettier eslint-config-prettier eslint-plugin-eslint-comments eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-jsx-a11y prettier prettier-config-ackama"
copy_file ".eslintrc.js"
template ".eslintignore.tt"
template ".prettierignore.tt"

package_json = JSON.parse(File.read("./package.json"))
package_json["prettier"] = "prettier-config-ackama"
package_json["browserslist"] = [
  "defaults",
  "not IE 11",
  "not IE_Mob 11"
]
package_json["scripts"] = {
  "js-lint" => "eslint . --ignore-pattern '!.eslintrc.js' --ext js,ts,tsx,jsx",
  "js-lint-fix" => "eslint . --ignore-pattern '!.eslintrc.js' --ext js,ts,tsx,jsx --fix",
  "format-check" => "prettier --check './**/*.{css,scss,json,md,js,ts,tsx,jsx}'",
  "format-fix" => "prettier --write './**/*.{css,scss,json,md,js,ts,tsx,jsx}'",
  "scss-lint" => "stylelint '**/*.{css,scss}'",
  "scss-lint-fix" => "stylelint '**/*.{css,scss}' --fix"
}

File.write("./package.json", JSON.generate(package_json))

# must be run after prettier is installed and has been configured by setting
# the 'prettier' key in package.json
run "yarn run js-lint-fix"
run "yarn run format-fix"

append_to_file "bin/ci-run" do
  <<~ESLINT

  echo "* ******************************************************"
  echo "* Running JS linting"
  echo "* ******************************************************"
  yarn run js-lint
  ESLINT
end

append_to_file "bin/ci-run" do
  <<~PRETTIER

  echo "* ******************************************************"
  echo "* Running JS linting"
  echo "* ******************************************************"
  yarn run format-check
  PRETTIER
end

# SCSS Linting
run "yarn add --dev stylelint stylelint-scss stylelint-config-recommended-scss"
copy_file ".stylelintrc.js"
template ".stylelintignore.tt"

append_to_file "bin/ci-run" do
  <<~SASSLINT

  echo "* ******************************************************"
  echo "* Running SCSS linting"
  echo "* ******************************************************"
  yarn run scss-lint
  SASSLINT
end
