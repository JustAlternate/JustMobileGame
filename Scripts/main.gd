extends Node2D

var score = 0
var nbr_dodges = 0
var nbr_powerups = 0
var bullet = preload("res://Scenes/bullet.tscn")
var player = preload("res://Scenes/player.tscn")
var gift = preload("res://Scenes/gift.tscn")
var player_instance = player.instantiate()
var dont_send = false

@export var time_before_next_bullet_spawn:float = 0.7
@export var bullet_speed:float = 2.0
var spawning_bullet = false
var dead = false

var list_effects = {
	"size_decrease":Color(0,255,0),
	"lightup":Color(255,255,0)
}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(player_instance)
	$bullets.speed = 2.0

func spawn_bullet():
	spawning_bullet = true
	var bullet_instance = bullet.instantiate()
	bullet_instance.position.x = randi_range(10,get_viewport_rect().size.x - 10)
	get_node("bullets").add_child(bullet_instance)
	await get_tree().create_timer(time_before_next_bullet_spawn).timeout
	spawning_bullet = false
	update_score_difficulty_and_spawn_gifts()

func spawn_gift():
	nbr_powerups+=1
	var gift_instance = gift.instantiate()
	gift_instance.type = list_effects.keys()[randi_range(0,len(list_effects)-1)]
	gift_instance.get_node("MeshInstance2D").modulate = list_effects[gift_instance.type]
	gift_instance.position.x = randi_range(10,get_viewport_rect().size.x - 10)
	get_node("gifts").add_child(gift_instance)
	
func receive_gift(type):
	print(type)
	if type == "size_decrease":
		score += 5
		$player.scale.x -= $player.scale.x/15
		$player.scale.y -= $player.scale.y/15
		$player.speed -= $player.speed/15
		$player/PointLight2D.texture_scale += $player/PointLight2D.texture_scale/15
	if type == "lightup":
		score += 5
		$player/PointLight2D.texture_scale+=0.5

func update_score_difficulty_and_spawn_gifts():
	if not(dead):
		score += 1
		$Score.text = str(score)
		if score%20==0:
			time_before_next_bullet_spawn-=time_before_next_bullet_spawn/10
		if score%25==0:
			$bullets.speed += 0.2
			$gifts.speed += 0.2
		if score%15==0:
			spawn_gift()
		if score%5==0:
			$player/PointLight2D.texture_scale -= 0.05
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not spawning_bullet and not dead:
		spawn_bullet()
	if Input.is_action_just_pressed("left"):
		$player.direction = -1
	if Input.is_action_just_pressed("right"):
		$player.direction = 1
	if Input.is_action_just_released("left"):
		$player.direction = 0
	if Input.is_action_just_released("right"):
		$player.direction = 0

func _on_gameover_button_pressed():
	for bullet in get_node("bullets").get_children():
		bullet.queue_free()
	$GameOver.visible = false
	time_before_next_bullet_spawn = 0.7
	$player.scale = Vector2(3,3)
	$bullets.speed = 2.0
	$gifts.speed = 2.0
	dead = false
	score = 0
	spawn_bullet()
	$player/PointLight2D.texture_scale = 3

func dying():
	if not dead:
		dead = true
		$GameOver.visible = true
		$GameOver/Label.text = "GAME OVER !\nYour Score is : "+str(score)
		$player/PointLight2D.texture_scale = 10
		dont_send = false
		apply_score(score,nbr_dodges,nbr_powerups)
		await get_tree().create_timer(0.5).timeout
		$GameOver/Leaderboard.update_leaderboard()

func _on_left_button_down():
	$player.direction = -1
func _on_left_button_up():
	$player.direction = 0
func _on_right_button_down():
	$player.direction = 1
func _on_right_button_up():
	$player.direction = 0

func usernameExist() -> bool:
	return(FileAccess.file_exists("user://username.txt"))

func createUsernameFile(username):
	var usernameFile = FileAccess.open("user://username.txt", FileAccess.WRITE)
	var json_to_save = JSON.stringify({"name":username})
	usernameFile.store_line(json_to_save)
	usernameFile.close()
	
func loadUsernameFile():
	var usernameFile = FileAccess.open("user://username.txt", FileAccess.READ)
	return (JSON.parse_string(usernameFile.get_line()))["name"]

func apply_score(score, nbr_dodges, nbr_powerups):
	var name = "None"
	if usernameExist():
		name = loadUsernameFile()
	
	else:
		$GameOver/UsernameInput.visible = true
		$GameOver/GAMEOVER_BUTTON.visible = false
		return
		
	var json = JSON.stringify({"name":name, "score":score,"dodges":nbr_dodges,"powerups":nbr_powerups})
	var headers = ["Content-Type: application/json"]
	var url = "https://justalternate.fr:8082/add_score"
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)
	dont_send = true

func _on_username_input_text_submitted(new_text):
	$GameOver/UsernameInput.visible = false
	createUsernameFile(new_text)
	$GameOver/GAMEOVER_BUTTON.visible = true
	if not dont_send:
		apply_score(score, nbr_dodges, nbr_powerups)
	$GameOver/Leaderboard.update_leaderboard()


func _on_reset_name_pressed():
	dont_send = true
	$GameOver/UsernameInput.visible = true
