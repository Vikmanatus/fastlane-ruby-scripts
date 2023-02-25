# frozen_string_literal: true
require 'fastlane'

Fastlane::Actions.load_default_actions
list = Fastlane::Actions.get_all_official_actions
list.each do |element|
  action_name = String(element).split('_').map(&:capitalize).join('')
  instance = Fastlane::Actions.action_class_ref(action_name)
  if instance
    description_method = instance.method(:description)
    description_content = description_method.call
    puts "Found description #{description_content}"
  end
  puts "Trying to find instance to call description method #{element.to_s}"
end


puts "Trying to fecth action list"
