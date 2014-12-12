require 'spec_helper'
require './lib/drupal/vocabulary'
require './lib/drupal/export'
require './spec/support/shared_configuration.rb'
require './spec/support/db_rows_json.rb'

module Contentful
  module Exporter
    module Drupal
      describe Vocabulary do

        include_context 'shared_configuration'

        before do
          exporter = Export.new(@config)
          @vocabulary = Vocabulary.new(exporter, @config)
          @row = json_fixture('database_rows/vocabulary')
        end

        it 'initialize' do
          expect(@vocabulary.config).to be_a Contentful::Configuration
          expect(@vocabulary.exporter).to be_a Contentful::Exporter::Drupal::Export
        end

        it 'save_vocabularies_as_json' do
          expect_any_instance_of(Contentful::Configuration).to receive(:db) { {taxonomy_vocabulary: [json_fixture('database_rows/vocabulary')]} }
          expect_any_instance_of(Vocabulary).to receive(:extract_data) { json_fixture('json_responses/vocabulary') }
          @vocabulary.save_vocabularies_as_json
        end

        it 'extract_data' do
          expect_any_instance_of(Vocabulary).to receive_message_chain(:map_fields) { json_fixture('json_responses/vocabulary') }
          @vocabulary.send(:extract_data, @row)
          tag_fixture = entry_fixture('vocabulary/vocabulary_3')
          expect(tag_fixture).to include(id: 'vocabulary_3', name: 'tag_name', description: 'Very bad tag', machine_name: 'bad')
        end

        it 'id' do
          tag_id = @vocabulary.send(:id, @row[:vid])
          expect(tag_id).to eq 'vocabulary_3'
        end

        it 'map_fields' do
          vocabulary = @vocabulary.send(:map_fields, @row)
          expect(vocabulary).to include(id: 'vocabulary_3', name: 'tag_name', description: 'Very bad tag', machine_name: 'bad')
        end

      end
    end
  end
end