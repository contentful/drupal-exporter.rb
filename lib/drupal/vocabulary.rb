module Contentful
  module Exporter
    module Drupal
      class Vocabulary

        attr_reader :exporter, :config

        def initialize(exporter, config)
          @exporter, @config = exporter, config
        end

        def save_vocabularies_as_json
          exporter.create_directory("#{config.entries_dir}/vocabulary")
          config.db[:taxonomy_vocabulary].each do |vocabulary_row|
            extract_data(vocabulary_row)
          end
        end

        private

        def extract_data(vocabulary_row)
          puts "Saving vocabulary - id: #{vocabulary_row[:vid]}"
          db_object = map_fields(vocabulary_row)
          exporter.write_json_to_file("#{config.entries_dir}/vocabulary/#{db_object[:id]}.json", db_object)
        end

        def map_fields(row, result = {})
          result[:id] = id(row[:vid])
          result[:name] = row[:name]
          result[:description] = row[:description]
          result[:machine_name] = row[:machine_name]
          result
        end

        def id(vocabulary_id)
          "vocabulary_#{vocabulary_id}"
        end

      end
    end
  end
end
