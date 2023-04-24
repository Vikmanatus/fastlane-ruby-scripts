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
valid_action_number = 0
invalid_action_number = 0
list.each do |element|
  action_name = element.to_s
  instance = Fastlane::Actions.action_class_ref(element)
  if instance
    puts "INSTANCE #{action_name}"
    valid_action_number += 1
    begin

      options_check = instance.method('available_options')
      if !options_check.call.nil? && !options_check.call.empty?
        hash_list = options_check.call.map do |config_item|
          if config_item.is_a?(FastlaneCore::ConfigItem)
            config_item_to_hash(config_item)
          else
            # puts "ACTION #{action_name} HAS INVALID CONFIG ITEM: #{config_item}"
          end
        end
        json_list = JSON.pretty_generate(hash_list)
        # puts "Fastlane_Action: #{json_list}"
      end
    rescue NameError => e
      invalid_action_number += 1
      puts "Skipping #{instance.to_s} due to an issue with uninitialized constants: #{e.message}"
    end
  else
    invalid_action_number += 1
    puts "NOT AN INSTANCE #{action_name}"
  end
end

puts "TOTAL ACTIONS: #{list.length}"
puts "VALID INSTANCES: #{valid_action_number}"
puts "INVALID INSTANCES: #{invalid_action_number}"


