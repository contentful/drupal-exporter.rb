require_relative 'drupal/export'
require_relative 'converters/contentful_model_to_json'
require_relative 'configuration'


class Migrator

  attr_reader :exporter, :config, :converter

  def initialize(settings)
    @config = Contentful::Configuration.new(settings)
    @exporter = Contentful::Exporter::Drupal::Export.new(config)
    @converter = Contentful::Converter::ContentfulModelToJson.new(config)
  end

  def run(action)
    case action.to_s
      when '--extract-to-json'
        exporter.save_data_as_json
      when '--convert-content-model-to-json'
        converter.convert_to_import_form
      when '--create-contentful-model-from-json'
        converter.create_content_type_json
      else
        fail ArgumentError, 'You have entered incorrect action! View README'
    end
  end
end
