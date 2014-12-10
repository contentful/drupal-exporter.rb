require_relative 'drupal/export'
require_relative 'configuration'


class Migrator

  attr_reader :exporter, :config

  def initialize(settings)
    @config = Contentful::Configuration.new(settings)
    @exporter = Contentful::Exporter::Drupal::Export.new(config)
  end

  def run(action)
    case action.to_s
      when '--extract-to-json'
        exporter.save_data_as_json
      else
        fail ArgumentError, 'You have entered incorrect action! Check README'
    end
  end
end
