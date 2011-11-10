#
# task add <task> [task] - Add a task
#
module.exports = (robot) ->
  robot.respond /(task add|add task) (.+?)$/i, (msg) ->
    robot.brain.data.tasks ?= []
    robot.brain.data.tasks.push msg.match[2]
    msg.send "task added"

  robot.respond /(task list|list tasks)/i, (msg) ->
    robot.brain.data.tasks ?= []
    if robot.brain.data.tasks.length > 0
      response = ""
      for task, num in robot.brain.data.tasks
        response += "##{num+1} - #{task}\n"
      msg.send response
    else
      msg.send "There are no tasks"

  robot.respond /(task delete|delete task) #?(\d)/i, (msg) ->
    taskNum = msg.match[2]
    robot.brain.data.tasks ?= []
    task = robot.brain.data.tasks.splice(taskNum-1, 1)[0]
    msg.send "Task deleted: #{task}"
