require './lib/configuration'

shared_context 'shared_configuration' do
  before do
    yaml_text = <<-EOF
          data_dir: spec/fixtures/drupal
          adapter: mysql2
          host: localhost
          database: drupal
          user: username
          password: secret_password

          drupal_content_types_json: spec/fixtures/settings/drupal_content_types.json
          drupal_boolean_columns: spec/fixtures/settings/boolean_columns.yml
          drupal_base_url: http://example_hostname.com
    EOF
    yaml = YAML.load(yaml_text)
    @config = Contentful::Configuration.new(yaml)
  end
end