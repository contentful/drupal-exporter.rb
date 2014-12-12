require 'spec_helper'
require './lib/drupal/tag'
require './lib/drupal/export'
require './spec/support/shared_configuration.rb'
require './spec/support/db_rows_json.rb'

module Contentful
  module Exporter
    module Drupal
      describe Tag do

        include_context 'shared_configuration'

        before do
          exporter = Export.new(@config)
          @tag = Tag.new(exporter, @config)
          @row = json_fixture('database_rows/tag')
        end

        it 'initialize' do
          expect(@tag.config).to be_a Contentful::Configuration
          expect(@tag.exporter).to be_a Contentful::Exporter::Drupal::Export
        end

        it 'save_tags_as_json' do
          expect_any_instance_of(Contentful::Configuration).to receive(:db) { {taxonomy_term_data: [json_fixture('database_rows/tag')]} }
          expect_any_instance_of(Tag).to receive(:extract_data) { json_fixture('json_responses/tag') }
          @tag.save_tags_as_json
        end

        it 'extract_data' do
          expect_any_instance_of(Tag).to receive_message_chain(:map_fields) { json_fixture('json_responses/tag') }
          @tag.send(:extract_data, @row)
          tag_fixture = entry_fixture('tag/tag_1')
          expect(tag_fixture).to include(id: 'tag_1', name: 'article tag', description: 'desc')
          expect(tag_fixture[:vocabulary]).to include(type: 'EntryVocabulary', id: 'vocabulary_1')
        end

        it 'map_fields' do
          expect_any_instance_of(Tag).to receive(:vocabulary) { {type: 'EntryVocabulary', id: 'vocabulary_1'} }
          tag = @tag.send(:map_fields, @row)
          expect(tag).to include(id: 'tag_1', name: 'article tag', description: 'desc')
          expect(tag[:vocabulary]).to include(type: 'EntryVocabulary', id: 'vocabulary_1')
        end

        it 'id' do
          tag_id = @tag.send(:id, @row[:tid])
          expect(tag_id).to eq 'tag_1'
        end

        it 'vocabulary' do
          expect_any_instance_of(Tag).to receive(:tag_vocabulary).with(1).and_return(json_fixture('database_rows/vocabulary'))
          vocabulary = @tag.send(:vocabulary, @row[:vid])
          expect(vocabulary).to include(type: 'EntryVocabulary', id: 'vocabulary_3')
        end

      end
    end
  end
end