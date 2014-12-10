require 'time'

module Contentful
  module Exporter
    module Drupal
      class Comment

        attr_reader :exporter, :config

        def initialize(exporter, config)
          @exporter, @config = exporter, config
        end

        def save_comments_as_json
          exporter.create_directory("#{config.entries_dir}/comment")
          config.db[:comment].each do |comment_row|
            extract_data(comment_row)
          end
        end

        private

        def extract_data(comment_row)
          puts "Saving comments - id: #{comment_row[:cid]}"
          db_object = map_fields(comment_row)
          exporter.write_json_to_file("#{config.entries_dir}/comment/#{db_object[:id]}.json", db_object)
        end

        def map_fields(row, result = {})
          result[:id] = id(row[:cid])
          result[:subject] = id(row[:subject])
          result[:body] = body(row[:cid])
          result[:entity] = entity(row[:nid])
          result[:author] = author(row[:uid])
          result[:created_at] = created_at(row[:created])
          result
        end

        def id(comment_id)
          'comment_' + comment_id.to_s
        end

        def entity(entity_id)
          type = config.db[:node].where(nid: entity_id).first[:type]
          {type: 'Entity', id: "#{type}_#{entity_id}"}
        end

        def body(comment_id)
          config.db[:field_data_comment_body].where(entity_id: comment_id).first[:comment_body_value]
        end

        def author(user_id)
          {type: 'Author', id: "user_#{user_id}"}
        end

        def created_at(timestamp)
          Time.at(timestamp).to_datetime
        end

      end
    end
  end
end