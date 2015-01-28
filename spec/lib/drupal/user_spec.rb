require 'spec_helper'
require './lib/drupal/user'
require './lib/drupal/export'
require './spec/support/shared_configuration.rb'
require './spec/support/db_rows_json.rb'

module Contentful
  module Exporter
    module Drupal
      describe User do

        include_context 'shared_configuration'

        before do
          exporter = Export.new(@config)
          @user = User.new(exporter, @config)
          @row = json_fixture('database_rows/user')
        end

        it 'initialize' do
          expect(@user.config).to be_a Contentful::Configuration
          expect(@user.exporter).to be_a Contentful::Exporter::Drupal::Export
        end

        it 'save_users_as_json' do
          expect_any_instance_of(Contentful::Configuration).to receive_message_chain(:db) { {users: [json_fixture('database_rows/user')]} }
          @user.save_users_as_json
        end

        it 'extract_data' do
          @user.send(:extract_data, @row)
          user = entry_fixture('user/user_1')
          expect(user).to include(id: 'user_1')
        end

        it 'map_fields' do
          user = @user.send(:map_fields, @row)
          expect(user).to include(id: 'user_1', email: 'useremail@gmail.com', name: 'username', created_at: 'Tue, 02 Dec 2014 11:45:50 +0100')
        end

        it 'id' do
          tag_id = @user.send(:id, @row[:uid])
          expect(tag_id).to eq 'user_1'
        end

      end
    end
  end
end