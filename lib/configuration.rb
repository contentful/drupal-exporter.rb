require 'sequel'
require 'active_support/core_ext/hash'

module Contentful
  class Configuration
    attr_reader :space_id,
                :config,
                :data_dir,
                :collections_dir,
                :entries_dir,
                :assets_dir,
                :db,
                :content_types,
                :drupal_content_types,
                :drupal_base_url

    def initialize(settings)
      @config = settings
      validate_required_parameters
      @data_dir = config['data_dir']
      @collections_dir = "#{data_dir}/collections"
      @entries_dir = "#{data_dir}/entries"
      @assets_dir = "#{data_dir}/assets"
      @space_id = config['space_id']
      @drupal_content_types = JSON.parse(File.read(config['drupal_content_types_json']), symbolize_names: true).with_indifferent_access
      @drupal_base_url = config['drupal_base_url']
      @db = adapter_setup
      @import_form_dir = config['import_form_dir']
      @content_types = config['content_model_json']
    end

    def validate_required_parameters
      define_data_dir
      define_adapter
      define_content_model_json
    end

    def define_data_dir
      fail ArgumentError, 'Set PATH to data_dir. Folder where all data will be stored. Check README' if config['data_dir'].nil?
    end

    def define_adapter
      %w(adapter user host database).each do |param|
        fail ArgumentError, "Set database connection parameters [adapter, host, database, user, password]. Missing the '#{param}' parameter! Password is optional. Check README!" unless config[param]
      end
    end

    def define_content_model_json
      fail ArgumentError, 'Set PATH to drupal_content_types_json. File with Drupal database structure. Check README' if config['drupal_content_types_json'].nil?
    end

    def adapter_setup
      Sequel.connect(:adapter => config['adapter'], :user => config['user'], :host => config['host'], :database => config['database'], :password => config['password'])
    end
  end
end