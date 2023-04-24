# frozen_string_literal: true
require 'fastlane'
require 'json'

Fastlane::Actions.load_default_actions

def config_item_to_hash(config_item)
  {
    key: config_item.key,
    env_name: config_item.env_name,
    description: config_item.description,
    default_value: config_item.default_value,
    optional: config_item.optional,
    is_string: config_item.is_string,
    data_type: config_item.data_type
  }
end

list = Fastlane::Actions.get_all_official_actions
list.each do |element|
  instance = Fastlane::Actions.action_class_ref(element)
  next unless instance

  begin
    options_check = instance.method('available_options')
    if !options_check.call.nil? && !options_check.call.empty?
      hash_list = options_check.call.map do |config_item|
        config_item.is_a?(FastlaneCore::ConfigItem) ? config_item_to_hash(config_item) : nil
      end
      json_list = JSON.pretty_generate(hash_list)
      puts "#{instance.to_s}: #{json_list}"
    end
  rescue NameError => e
    puts "Skipping #{instance.to_s} due to an issue with uninitialized constants: #{e.message}"
  end
end
