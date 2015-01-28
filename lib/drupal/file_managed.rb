module Contentful
  module Exporter
    module Drupal
      class FileManaged

        attr_reader :exporter, :config

        def initialize(exporter, config)
          @exporter, @config = exporter, config
        end

        def save_files_as_json
          exporter.create_directory("#{config.assets_dir}/file")
          config.db[:file_managed].each do |file_row|
            extract_data(file_row)
          end
        end

        private

        def extract_data(file_row)
          puts "Saving file - id: #{file_row[:fid]}"
          db_object = map_fields(file_row)
          exporter.write_json_to_file("#{config.assets_dir}/file/#{db_object[:id]}.json", db_object)
        end

        def map_fields(row, result = {})
          result[:id] = id(row[:fid])
          result[:title] = row[:filename]
          result[:description] = row[:description]
          result[:url] = "#{config.drupal_base_url}/#{row[:uri].gsub(' ', '%20').gsub('public://','sites/default/files/')}"
          result
        end

        def id(file_id)
          "file_#{file_id}"
        end

      end
    end
  end
end
