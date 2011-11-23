#
# task add <task> - Add a task
# task list <task> - List the tasks
# task delete <task number> - Delete a task
#


class Tasks
  constructor: (@robot) ->
    @robot.brain.on 'loaded', =>
      @robot.brain.data.tasks ?= []
  nextTaskNum: ->
    tasks = @robot.brain.data.tasks
    maxTaskNum = if tasks.length then Math.max.apply(Math,tasks.map (n) -> n.num) else 0
    maxTaskNum++
    maxTaskNum
  add: (taskString) ->
    task = {num: @nextTaskNum(), task: taskString}
    @robot.brain.data.tasks.push task
    task
  all: -> @robot.brain.data.tasks
  deleteByNumber: (num) ->
    index = @robot.brain.data.tasks.map((n) -> n.num).indexOf(parseInt(num))
    @robot.brain.data.tasks.splice(index, 1)[0]

module.exports = (robot) ->
  tasks = new Tasks robot

  robot.respond /(task add|add task) (.+?)$/i, (msg) ->
    task = tasks.add msg.match[2]
    msg.send "task added: ##{task.num} - #{task.task}"

  robot.respond /(task list|list tasks)/i, (msg) ->
    if tasks.all().length > 0
      response = ""
      for task, num in tasks.all()
        response += "##{task.num} - #{task.task}\n"
      msg.send response
    else
      msg.send "There are no tasks"

  robot.respond /(task delete|delete task) #?(\d+)/i, (msg) ->
    taskNum = msg.match[2]
    task = tasks.deleteByNumber taskNum
    msg.send "Task deleted: #{task.num} - #{task.task}"
