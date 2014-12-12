require 'spec_helper'
require './lib/drupal/file_managed'
require './lib/drupal/export'
require './spec/support/shared_configuration.rb'
require './spec/support/db_rows_json.rb'

module Contentful
  module Exporter
    module Drupal
      describe FileManaged do

        include_context 'shared_configuration'

        before do
          exporter = Export.new(@config)
          @file = FileManaged.new(exporter, @config)
          @row = json_fixture('database_rows/image')
        end

        it 'initialize' do
          expect(@file.config).to be_a Contentful::Configuration
          expect(@file.exporter).to be_a Contentful::Exporter::Drupal::Export
        end

        it 'save_files_as_json' do
          expect_any_instance_of(Contentful::Configuration).to receive(:db) { {file_managed: [json_fixture('database_rows/image')]} }
          expect_any_instance_of(FileManaged).to receive(:extract_data) { json_fixture('json_responses/image') }
          @file.save_files_as_json
        end

        it 'extract_data' do
          expect_any_instance_of(FileManaged).to receive_message_chain(:map_fields) { json_fixture('json_responses/image') }
          @file.send(:extract_data, @row)
          file = asset_fixture('file/file_4')
          expect(file).to include(id: 'file_4', title: 'ruby.png', url: 'http://example_hostname.com/sites/default/files/ruby.png')
        end

        it 'map fields' do
          result = @file.send(:map_fields, @row)
          expect(result).to include(id: 'file_1', title: 'Screen Shot 2014-11-27 at 12.34.47 PM.png', url: 'http://example_hostname.com/sites/default/files/field/image/Screen%20Shot%202014-11-27%20at%2012.34.47%20PM.png')
        end

        it 'id' do
          file_id = @row[:fid]
          id = @file.send(:id, file_id)
          expect(id).to eq "file_#{file_id}"
        end

      end
    end
  end
end