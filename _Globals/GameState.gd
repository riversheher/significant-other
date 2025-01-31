extends Node

var unlocked_rooms = {
	"livingroom": false, 
	"washroom": false
}
var solved_puzzles = {
	"bedroom window": false, 
	"washroom cheese": false, 
	"puzzle3": false
}

func unlock_room(room_name):
	unlocked_rooms[room_name] = true

func mark_puzzle_solved(puzzle_name):
	solved_puzzles[puzzle_name] = true
	
	# Additional logic for what gets unlocked and what gets triggered when the
	# puzzle is solved.
	match puzzle_name:
		"bedroom window":
			unlocked_rooms["livingroom"] = true
		"washroom cheese":
			unlocked_rooms["washroom"] = true
	
