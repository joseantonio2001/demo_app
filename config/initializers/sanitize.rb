# config/initializers/sanitize.rb
#
# Default configuration for the Sanitize gem, provided by secure_framework.
# This is a strict configuration that strips all HTML tags to prevent formatting.
# For more information on options: https://github.com/rgrove/sanitize

Sanitize::Config::SECURE_FRAMEWORK = {
  # No HTML elements are allowed. The list is empty.
  :elements => [],

  # As an additional security measure, ensure the contents of these
  # tags are also removed, in case an external configuration allows them.
  :remove_contents => ['script', 'style']
}
