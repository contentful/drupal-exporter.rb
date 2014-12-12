require 'spec_helper'
require './lib/drupal/content_type'
require './lib/drupal/export'
require './spec/support/shared_configuration.rb'
require './spec/support/db_rows_json.rb'

module Contentful
  module Exporter
    module Drupal
      describe ContentType do

        include_context 'shared_configuration'

        before do
          @exporter = Export.new(@config)
          @type = 'article'
          @row = json_fixture('database_rows/node_content_type_article')
          @content_type = ContentType.new(@exporter, @config, @type, @row)
        end

        it 'initialize' do
          expect(@content_type.config).to be_a Contentful::Configuration
          expect(@content_type.exporter).to be_a Contentful::Exporter::Drupal::Export
        end

        it 'extract_data' do
          expect_any_instance_of(ContentType).to receive(:map_fields) { json_fixture('json_responses/article') }
          @content_type.send(:extract_data, @row)
          article = entry_fixture('article/article_5')
          expect(article).to include(id: 'article_5', title: 'Article first title', body: 'Article first body!')
          expect(article[:comments].count).to eq 2
          expect(article[:tags].count).to eq 2
          expect(article[:comments].first).to include(type: 'EntryComment', id: 'comment_3')
          expect(article[:image]).to include(type: 'File', id: 'file_1')
        end

        it 'map_fields' do
          expect_any_instance_of(ContentType).to receive(:set_default_data) { {data: 'default'} }
          expect_any_instance_of(ContentType).to receive(:find_related_data) { {data2: 'related'} }
          result = @content_type.send(:map_fields, @row)
          expect(result.count).to eq 2
          expect(result).to include(data: 'default', data2: 'related')
        end

        it 'id' do
          content_type_id = @content_type.send(:id, @row[:nid])
          expect(content_type_id).to eq "#{@type}_#{@row[:nid]}"
        end

        it 'author' do
          author = @content_type.send(:author, @row[:uid])
          expect(author).to include(type: 'Author', id: 'user_1')
        end

        it 'related_table_name' do
          related_table = @content_type.send(:related_table_name, 'test')
          expect(related_table).to eq :field_data_test
        end

        it 'field_name' do
          field_name = @content_type.send(:field_name, 'test')
          expect(field_name).to eq :test_value
        end

        it 'created_at' do
          created_at = @content_type.send(:created_at, 1418292000)
          expect(created_at).to eq 'Thu, 11 Dec 2014 11:00:00 +0100'
        end

        context 'convert_type_value' do
          it 'convert to float when BigDecimal type' do
            big_decimal = BigDecimal.new('123')
            value = @content_type.send(:convert_type_value, big_decimal, 'test_column')
            expect(value).to eq 123.0
          end
          it 'convert to true value when boolean type' do
            @exporter.boolean_columns << ['test_column']
            value = @content_type.send(:convert_type_value, 1, 'test_column')
            expect(value).to be true
          end
          it 'convert to false value when boolean type' do
            @exporter.boolean_columns << ['test_column']
            value = @content_type.send(:convert_type_value, 0, 'test_column')
            expect(value).to be false
          end
          it 'convert to nil value when boolean type' do
            @exporter.boolean_columns << ['test_column']
            value = @content_type.send(:convert_type_value, nil, 'test_column')
            expect(value).to be_nil
          end
          it 'return value' do
            value = @content_type.send(:convert_type_value, 'value', 'just_value')
            expect(value).to eq 'value'
          end
        end

        context 'boolean_column' do
          it 'return true' do
            @exporter.boolean_columns << ['test_column']
            value = @content_type.send(:boolean_column?, 'test_column')
            expect(value).to be true
          end
          it 'return false' do
            value = @content_type.send(:boolean_column?, 'some_column')
            expect(value).to be false
          end
        end

        it 'link_asset_to_content_type' do
          file_asset_id = 22
          value = @content_type.send(:link_asset_to_content_type, file_asset_id)
          expect(value).to include(type: 'File', id: "file_#{file_asset_id}")
        end

        it 'get_file_id' do
          expect_any_instance_of(ContentType).to receive(:file_id) { 1 }
          related_row = [json_fixture('database_rows/content_type_article')]
          value = @content_type.send(:get_file_id, related_row, 'table_name')
          expect(value).to include(type: 'File', id: 'file_1')
        end

      end
    end
  end
end