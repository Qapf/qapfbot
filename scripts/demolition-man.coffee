# Description:
#   Watch your language!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   whitman, jan0sch
points = {}

words = [
  'arsch',
  'arschloch',
  'arse',
  'ass',
  'bastard',
  'bitch',
  'bugger',
  'bollocks',
  'bullshit',
  'cock',
  'cunt',
  'damn',
  'damnit',
  'depp',
  'dick',
  'douche',
  'fag',
  'fotze',
  'fuck',
  'fucked',
  'fucking',
  'kacke',
  'piss',
  'pisse',
  'scheisse',
  'schlampe',
  'shit',
  'wank',
  'wichser'
]

print_points = (msg, username, pts) ->
    console.log "assigning #{pts} points to #{username}"
    points[username] ?= 0
    console.log "#{username} has #{points[username]}"
    points[username] -= parseInt(pts)
    console.log "#{username} now has #{points[username]} points"
    msg.send "#{username} now has #{points[username]} points"

replyTo = (user, msg) ->
  robot.send({user: {name: user}}, msg)
save = (robot) ->
  robot.brain.data.points = points

module.exports = (robot) ->
  robot.brain.on 'loaded', ->
    points = robot.brain.data.points or {}

  regex = new RegExp('(?:^|\\s)(' + words.join('|') + ')(?:\\s|\\.|\\?|!|$)', 'i');

  robot.hear regex, (msg) ->
    username = msg.message.user.name
    msg.send "You have been fined one credit for a violation of the verbal morality statute."
    print_points(msg, username, 1)
