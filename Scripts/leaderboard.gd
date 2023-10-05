extends Control

var case = preload("res://Scenes/case.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_leaderboard():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://justalternate.fr:8082/leaderboard")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	draw_leaderboard(json)

func draw_leaderboard(leaderboard):
	clear_leaderboard()
	var i = 0
	for player in leaderboard:
		i+=1
		var rank_case = case.instantiate()
		rank_case.text = str(i)
		var name_case = case.instantiate()
		name_case.text = str(player[0])
		var score_case = case.instantiate()
		score_case.text = str(player[1])
		var dodge_case = case.instantiate()
		dodge_case.text = str(player[2])
		var powerups_case = case.instantiate()
		powerups_case.text = str(player[3])
		$ScrollContainer/GridContainer.add_child(rank_case)
		$ScrollContainer/GridContainer.add_child(VSeparator.new())
		$ScrollContainer/GridContainer.add_child(name_case)
		$ScrollContainer/GridContainer.add_child(VSeparator.new())

		$ScrollContainer/GridContainer.add_child(score_case)
		$ScrollContainer/GridContainer.add_child(VSeparator.new())

		$ScrollContainer/GridContainer.add_child(dodge_case)
		$ScrollContainer/GridContainer.add_child(VSeparator.new())

		$ScrollContainer/GridContainer.add_child(powerups_case)


func clear_leaderboard():
	var list_children = $ScrollContainer/GridContainer.get_children()
	for i in range(len(list_children)):
		if i > 8: # Pour pas effacer les placeholders
			list_children[i].queue_free()

