module Validator
  extend ActiveSupport::Concern

  ACTIONS = ['recommends', 'accepts']

  def validate(data)
    data.map.with_index do |line, index|
      validate_line(line.strip.split(' '), index)
    end.compact
  end

  def validation_errors
    @errors ||= []
  end

  private

  def validate_line(line, index)
    time = validate_datetime(line, index)
    action = validate_action(line, index)
    validation_errors.empty? ? output(time, action, line, index) : nil
  end

  def validate_datetime(line, index)
    Time.parse("#{line[0]} #{line[1]}")
  rescue ArgumentError
    @errors << {line_num: index + 1, msg: "Datetime is invalid"}
  end

  def validate_action(line, index)
    action = line[3]
    @errors << {line_num: index + 1, msg: "Action is invalid"} unless ACTIONS.include?(line[3])
    @errors << {line_num: index + 1, msg: "Inviter and Invitee can't be same"} if action == ACTIONS[0] && line[2] == line[4]
    action
  end

  def output(time, action, line, index)
    line_hash = {time: time, index: index}
    action_hash = action == ACTIONS[1] ? {node: line[2], accepts: true} : {node: line[4], parent: line[2]}
    line_hash.merge(action_hash)
  end
end