module Contentful
  module Exporter
    module Drupal
      class User

        attr_reader :exporter, :config

        def initialize(exporter, config)
          @exporter, @config = exporter, config
        end

        def save_users_as_json
          exporter.create_directory("#{config.entries_dir}/user")
          config.db[:users].each do |user_row|
            extract_data(user_row)
          end
        end

        private

        def extract_data(user_row)
          puts "Saving user - id: #{user_row[:uid]}"
          db_object = map_fields(user_row)
          exporter.write_json_to_file("#{config.entries_dir}/user/#{db_object[:id]}.json", db_object)
        end

        def map_fields(row, result = {})
          result[:id] = id(row[:uid])
          result[:name] = row[:name]
          result[:email] = row[:mail]
          result[:created_at] = created_at(row[:created])
          result
        end

        def id(user_id)
          "user_#{user_id}"
        end

        def created_at(timestamp)
          Time.at(timestamp).to_datetime
        end

      end
    end
  end
end
