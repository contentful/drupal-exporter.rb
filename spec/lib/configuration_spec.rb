require 'spec_helper'
require './lib/configuration'
require './spec/support/shared_configuration.rb'

module Contentful
  describe Configuration do

    include_context 'shared_configuration'

    it 'initialize' do
      expect(@config.assets_dir).to eq 'spec/fixtures/drupal/assets'
      expect(@config.collections_dir).to eq 'spec/fixtures/drupal/collections'
      expect(@config.data_dir).to eq 'spec/fixtures/drupal'
      expect(@config.entries_dir).to eq 'spec/fixtures/drupal/entries'
    end

  end
end
