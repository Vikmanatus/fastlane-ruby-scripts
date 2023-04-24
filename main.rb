# frozen_string_literal: true
require 'fastlane'
require 'json'


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

action_file_paths = Fastlane::Actions.load_default_actions
file_paths_list = action_file_paths.map do |file_path|
  action_name = File.basename(file_path, '.rb')
  { 'action_name' => action_name, 'file_path' => file_path }
end

File.open('./file_path.json', 'w') do |f|
  f.write(JSON.pretty_generate(file_paths_list))
end

list = Fastlane::Actions.get_all_official_actions
valid_action_number = 0
invalid_action_number = 0
completion_list = []
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
            # TODO: fix the invalid config elements
            puts "ACTION #{action_name} HAS INVALID CONFIG ITEM: #{config_item}"
          end
        end
        completion_list.append({ 'action_name' => action_name, 'args' => hash_list })
      end
    rescue NameError => e
      invalid_action_number += 1
      puts "Skipping #{instance.to_s} due to an issue with uninitialized constants: #{e.message}"
      completion_list.append({ 'action_name' => action_name, 'args' => nil })
    end
  else
    invalid_action_number += 1
    puts "NOT AN INSTANCE #{action_name}"
  end
end

puts "TOTAL ACTIONS: #{list.length}"
puts "VALID INSTANCES: #{valid_action_number}"
puts "INVALID INSTANCES: #{invalid_action_number}"


File.open('./temp.json', 'w') do |f|
  f.write(JSON.pretty_generate(completion_list))
end
# Create a hash to store merged elements
merged_hash = {}

# Add all elements from list_1 to the merged_hash
file_paths_list.each do |element|
  action_name = element["action_name"]
  merged_hash[action_name] = element
end

# Merge elements from list_2 into the merged_hash
completion_list.each do |element|
  action_name = element["action_name"]
  if merged_hash.key?(action_name)
    merged_hash[action_name] = merged_hash[action_name].merge(element)
  else
  end
end


merged_hash.delete_if { |action_name, _| !completion_list.any? { |el| el["action_name"] == action_name } }

# Convert the merged_hash back into an array
merged_list = merged_hash.values
File.open('./merged.json', 'w') do |f|
  f.write(JSON.pretty_generate(merged_list))
end

# Merging the lists
