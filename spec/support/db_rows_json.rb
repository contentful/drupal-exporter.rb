require 'multi_json'

def json_fixture(file, _as_json = false)
  MultiJson.load(
      File.read(File.dirname(__FILE__) + "/../fixtures/#{file}.json")
  ).with_indifferent_access
end

def entry_fixture(file, _as_json = false)
  JSON.parse(File.read(File.dirname(__FILE__) + "/../fixtures/drupal/entries/#{file}.json")).with_indifferent_access
end

def asset_fixture(file, _as_json = false)
  JSON.parse(File.read(File.dirname(__FILE__) + "/../fixtures/drupal/assets/#{file}.json")).with_indifferent_access
end