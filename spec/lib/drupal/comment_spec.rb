require 'spec_helper'
require './lib/drupal/comment'
require './lib/drupal/export'
require './spec/support/shared_configuration.rb'
require './spec/support/db_rows_json.rb'

module Contentful
  module Exporter
    module Drupal
      describe Comment do

        include_context 'shared_configuration'

        before do
          exporter = Export.new(@config)
          @comment = Comment.new(exporter, @config)
          @row = json_fixture('database_rows/comment')
        end

        it 'initialize' do
          expect(@comment.config).to be_a Contentful::Configuration
          expect(@comment.exporter).to be_a Contentful::Exporter::Drupal::Export
        end

        it 'save_comments_as_json' do
          expect_any_instance_of(Contentful::Configuration).to receive(:db) { {comment: [json_fixture('database_rows/comment')]} }
          expect_any_instance_of(Comment).to receive(:extract_data) { json_fixture('json_responses/comment') }
          @comment.save_comments_as_json
        end

        it 'extract_data' do
          expect_any_instance_of(Comment).to receive_message_chain(:map_fields) { json_fixture('json_responses/comment') }
          @comment.send(:extract_data, @row)
          tag_fixture = entry_fixture('comment/comment_1')
          expect(tag_fixture).to include(id: 'comment_1', subject: 'subject of comment', body: 'amazing comment')
          expect(tag_fixture['entity']).to include(type: 'Entity', id: 'blog_2')
          expect(tag_fixture['author']).to include(type: 'Author', id: 'user_1')
        end

        it ' map_fields ' do
          expect_any_instance_of(Comment).to receive(:entity).with(@row[:nid]) { {type: 'Entity', id: 'blog_2'} }
          expect_any_instance_of(Comment).to receive(:body).with(@row[:cid]) { 'amazing comment' }
          comment = @comment.send(:map_fields, @row)
          expect(comment).to include(id: 'comment_1', subject: 'subject of comment', body: 'amazing comment')
          expect(comment[:entity]).to include(type: 'Entity', id: 'blog_2')
          expect(comment[:author]).to include(type: 'Author', id: 'user_1')
        end

        it 'id' do
          tag_id = @comment.send(:id, @row[:cid])
          expect(tag_id).to eq 'comment_1'
        end

        it 'author' do
          author = @comment.send(:author, @row[:uid])
          expect(author).to include(type: 'Author', id: 'user_1')
        end
      end
    end
  end
end