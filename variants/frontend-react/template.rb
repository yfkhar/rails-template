source_paths.unshift(File.dirname(__FILE__))

puts "Adding react-rails to Gemfile"

gem "react-rails"
run "bundle install"

run "rails webpacker:install:react"
run "rails generate react:install"

yarn_add_dev_dependencies %w[
  @testing-library/react
  @testing-library/jest-dom
  @testing-library/user-event
  eslint-plugin-react
  eslint-plugin-react-hooks
  eslint-plugin-jsx-a11y
  eslint-plugin-jest
  eslint-plugin-jest-formatting
  eslint-plugin-jest-dom
  eslint-plugin-testing-library
  jest
]
copy_file ".eslintrc.js", force: true

# remove example generated by default
remove_file "app/frontend/packs/hello_react.jsx"

react_rails_replacement = <<~REPLACEMENT
  // eslint-disable-next-line react-hooks/rules-of-hooks
  ReactRailsUJS.useContext(componentRequireContext);
REPLACEMENT

gsub_file "app/frontend/packs/application.js",
          "ReactRailsUJS.useContext(componentRequireContext);", react_rails_replacement

gsub_file "app/frontend/packs/server_rendering.js",
          "ReactRailsUJS.useContext(componentRequireContext);", react_rails_replacement

gsub_file(
  "app/frontend/packs/application.js",
  'var ReactRailsUJS = require("react_ujs")',
  ""
)

prepend_to_file "app/frontend/packs/application.js",
                 "import ReactRailsUJS from 'react_ujs';\n"

gsub_file(
  "app/frontend/packs/server_rendering.js",
  'var ReactRailsUJS = require("react_ujs")',
  "import ReactRailsUJS from 'react_ujs';"
)

# var ReactRailsUJS = require('react_ujs');
# import ReactRailsUJS from 'react_ujs';

javascript_pack_tag_replacement = <<-ERB
    <%= javascript_pack_tag "application", "data-turbolinks-track": "reload", defer: true %>
    <%= javascript_pack_tag "application" %>
ERB
gsub_file "app/views/layouts/application.html.erb",
          "    <%= javascript_pack_tag \"application\", \"data-turbolinks-track\": \"reload\", defer: true %>\n",
          javascript_pack_tag_replacement

copy_file "jest.config.js"

# example file
copy_file "app/frontend/components/HelloWorld.jsx", force: true

# test files
directory "app/frontend/test"

append_to_file "app/views/home/index.html.erb" do
  <<~ERB
    <%= react_component("HelloWorld", { initialGreeting: "Hello from react-rails." }) %>
  ERB
end

package_json = JSON.parse(File.read("./package.json"))
package_json["scripts"] = package_json["scripts"].merge(
  {
    "test" => "jest",
    "watch-tests" => "jest --watch"
  }
)

File.write("./package.json", JSON.generate(package_json))
