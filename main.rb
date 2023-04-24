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
  if instance
    options_check = instance.method("available_options")
    if options_check.call
      hash_list = options_check.call.map { |config_item| config_item_to_hash(config_item) }
      json_list = JSON.pretty_generate(hash_list)
      puts "args: #{json_list}"

    end
  end
end
# Fastlane::Actions.load_default_actions
# list = Fastlane::Actions.get_all_official_actions
# list.each do |element|
#   action_name = String(element).split('_').map(&:capitalize).join('')
#   instance = Fastlane::Actions.action_class_ref(action_name)
#   if instance
#     description_method = instance.method(:available_options)
#     if description_method
#       description_content = description_method.call
#       puts "Found description #{description_content}"
#     end
#   end
# end






