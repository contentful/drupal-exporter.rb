module Contentful
  module Exporter
    module Drupal
      class Tag

        attr_reader :exporter, :config

        def initialize(exporter, config)
          @exporter, @config = exporter, config
        end

        def save_tags_as_json
          exporter.create_directory("#{config.entries_dir}/tag")
          config.db[:taxonomy_term_data].each do |tag_row|
            extract_data(tag_row)
          end
        end

        private

        def extract_data(tag_row)
          puts "Saving tag - id: #{tag_row[:tid]}"
          db_object = map_fields(tag_row)
          exporter.write_json_to_file("#{config.entries_dir}/tag/#{db_object[:id]}.json", db_object)
        end

        #TODO VID??
        def map_fields(row, result = {})
          result[:id] = id(row[:tid])
          result[:name] = row[:name]
          result[:description] = row[:description]
          result[:vocabulary] = vocabulary(row[:vid])
          result
        end

        def id(tag_id)
          'tag_' + tag_id.to_s
        end

        def vocabulary(tag_vocabulary_id)
          vocabulary = tag_vocabulary(tag_vocabulary_id)
          {type: 'EntryVocabulary', id: "vocabulary_#{vocabulary[:vid]}"}
        end

        def tag_vocabulary(tag_vocabulary_id)
          config.db[:taxonomy_vocabulary].where(vid: tag_vocabulary_id).first
        end

      end
    end
  end
end

