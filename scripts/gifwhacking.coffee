# Description:
#   Gifwhacking v0.1
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   gifwhack rules
#	gifwhack score
#	gifwhack point [username]
#	gifwhack reset [username]
#
# Author:
#   Danny Olefsky (@Zedarius)

rules = [
  "- The goal is to make a (near) perfect match of two animated .GIF's in a row.",
  "- Start the game by using the 'gw [search query]' command to pull something obscure.",
  "- In turn order, players try to match the previously returned .gif with a new search query.",
  "- When a match is made, use the 'gifwhack point [name]' command to add a point to that person.", 
  "- The winner starts a new query, and play continues. Use 'gifwhack point [username]' to keep score!",
  " ",
  "* You can NOT use words from the URL itself",
  "* You CAN (and should) use words displayed in the image, although it's unsportsmanlike to fully quote the entire block of text."
  ]
  
commands = [
  "- gw [search query]: Pull an animated image from Google! The very essence of Gifwhacking.",
  "- gifwhack rules: Displays the rules",
  "- gifwhack point [username]: Gives one point to [username].",
  "- gifwhack score: Displays the current scoreboard.",
  "- gifwhack reset [username]: Sets a player's score to zero."  
  ]
  
yays = [
  "Bam",
  "Bingo",
  "Blam",
  "Blamo",
  "Cool",
  "Dear me",
  "Eureka",
  "Gee whiz",
  "Gee",
  "Golly",
  "Goodness me",
  "Goodness",
  "Great job",
  "Great",
  "Hallelujah",
  "Holy cow",
  "Holy mackerel",
  "Holy moly"
  "Holy smokes",
  "Hot dawg",
  "Hurrah",
  "Hurray",
  "I can't even",
  "Mazel tov",
  "My gosh",
  "No way",
  "Shazoom",
  "Sick",
  "That was easy",
  "Too easy",
  "Wahoo",
  "Wham-o",
  "Wham",
  "Whammy",
  "Wicked",
  "Wow",
  "Wowzers",
  "Yahoo",
  "Yippie",
  "You're amazing",
  "You're the best",
  ]

points = {}

award_points = (msg, username, pts) ->
    console.log "assigning #{pts} points to #{username}"
    points[username] ?= 0
    console.log "#{username} has #{points[username]}"
    points[username] += parseInt(pts)
    console.log "#{username} now has #{points[username]}"
    msg.send "#{username} now has #{points[username]}"

save = (robot) ->
    robot.brain.data.points = points

module.exports = (robot) ->
#first, we make sure the brain is loaded before we pull things out
  robot.brain.on 'loaded', ->
#then, we pull the value of point sback out of brain.data, or we give it an empty array
    points = robot.brain.data.points or {}
   
  robot.hear /gifwhack rules/i, (msg) ->
    msg.send rules.join('\n')
    
  robot.hear /gifwhack help/i, (msg) ->
    msg.send commands.join('\n')
  
  robot.hear /gifwhack point (.*)/i, (msg) ->
    console.log 'begin execution'
    victory = msg.random yays
    console.log "victory message set to #{victory}"
    award_points(msg, msg.match[1], '1')
    msg.send "#{victory} #{msg.match[1]}! Start a new chain! The more obscure the better."
    save(robot) 

  robot.hear /gifwhack score/i, (msg) ->
    scores = ["*** Gifwhacking Scoreboard ***"]
 #   users = robot.brain.users()
 #   if users.length!=undefined
 #     msg.send "No current scores."
    for username,value of points
      do (username) ->
        scores.push "#{username}: #{value}"
    msg.send scores.join("\n")

# Attempting to run the reset function through all players.    
#  robot.respond /gifwhack reset/i, (msg) ->
#    users = robot.brain.users()
#    for index,player of users
#      do (player) ->
#        msg.send "test 1"
#        users = points - points
#        msg.send "test 2"
#        msg.send "Current score for #{player}: #{user.cah}"
#        msg.send "test 3"
#    msg.send "SCORES RESET!"


  robot.hear /gifwhack reset (.*)/i, (msg) ->
    winner   = msg.match[1].trim()
    user     = robot.brain.userForName(winner)
    points   = user.gifwhacking || 0
    if winner.toLowerCase() == msg.message.user.name.toLowerCase()
      user.gifwhacking = points - points
      msg.send "#{winner}'s score reset to 0"
    else
      msg.send "Only #{winner} can reset his/her own score."
