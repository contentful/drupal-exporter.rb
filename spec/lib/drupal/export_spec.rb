require 'spec_helper'
require './lib/drupal/export'
require './spec/support/shared_configuration.rb'

module Contentful
  module Exporter
    module Drupal
      describe Export do

        include_context 'shared_configuration'

        before do
          @exporter = Export.new(@config)
        end

        it 'initialize' do
          expect(@exporter.config).to be_kind_of Contentful::Configuration
          expect(@exporter.boolean_columns).to be_a Array
        end

        it 'save_data_as_json' do
          expect_any_instance_of(Export).to receive(:comments)
          expect_any_instance_of(Export).to receive(:tags)
          expect_any_instance_of(Export).to receive(:vocabularies)
          expect_any_instance_of(Export).to receive(:users)
          expect_any_instance_of(Export).to receive(:content_types)
          expect_any_instance_of(Export).to receive(:files)
          @exporter.save_data_as_json
        end

      end
    end
  end
end