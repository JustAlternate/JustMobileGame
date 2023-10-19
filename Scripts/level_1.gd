extends Node2D

var score = 0
var nbr_dodges = 0
var nbr_powerups = 0
var min_speed = 50
var diff = GlobalVARS.diff
const bullet = preload("res://Scenes/bullet.tscn")
const player = preload("res://Scenes/player.tscn")
const gift = preload("res://Scenes/gift.tscn")
const flying_label_script = preload("res://Scripts/flying_label.gd")
var player_instance = player.instantiate()
var spawning_bullet = false
var dead = false
var json_file_name = GlobalVARS.json_file_name
var json_as_text = FileAccess.get_file_as_string("res://Assets/"+json_file_name )
var data = JSON.parse_string(json_as_text)
var data_index = 0
var level_nbr = 1

var rng = RandomNumberGenerator.new()


@onready var MusicPlayer = get_node("MusicPlayer1")

# Called when the node enters the scene tree for the first time.
func _ready():
	json_file_name = GlobalVARS.json_file_name
	json_as_text = FileAccess.get_file_as_string("res://Assets/"+json_file_name )
	data = JSON.parse_string(json_as_text)
	data_index = 0
	rng.set_seed(1)
	rng.set_state(1)
	diff = GlobalVARS.diff
	print(diff)
	if GlobalVARS.song == "At Dooms Gate 8 Bit Cover Tribute to Doom 8 Bit Universe.mp3":
		MusicPlayer = get_node("MusicPlayer1")
	if GlobalVARS.song == "My Chemical Romance - Helena (8-bit Cover).mp3":
		MusicPlayer = get_node("MusicPlayer2")
		level_nbr = 2
	if GlobalVARS.song == "Gravity Falls Theme 8 Bit Tribute to Gravity Falls 8 Bit Universe.mp3":
		MusicPlayer = get_node("MusicPlayer3")
		level_nbr = 3
	if GlobalVARS.song == "Teenage Mutant Ninja Turtles Theme Song 8 Bit Remix Cover Version 8 Bit Universe.mp3":
		MusicPlayer = get_node("MusicPlayer4")
		level_nbr = 4
	if GlobalVARS.song == "te rickrollearon en 8bit.mp3":
		MusicPlayer = get_node("MusicPlayer5")
		level_nbr = 5
	if GlobalVARS.song == "Warriors 8 Bit Remix Cover Version Tribute to Imagine Dragons 8 Bit Universe.mp3":
		MusicPlayer = get_node("MusicPlayer6")
		level_nbr = 6
	if GlobalVARS.song == "Megalovania Undertale 8 Bit Universe Version.mp3":
		MusicPlayer = get_node("MusicPlayer7")
		level_nbr = 7
	if GlobalVARS.song == "Through The Fire and Flames 8 Bit Cover Tribute to Dragonforce 8 Bit Universe.mp3":
		MusicPlayer = get_node("MusicPlayer8")
		level_nbr = 8
		
	$CanvasModulate.visible = true
	player_instance.speed += 0.5*diff
	add_child(player_instance)
	$player.scale = Vector2(2,2)
	$player/PointLight2D.texture_scale = 6
	
	MusicPlayer.play()
	
	
func spawn_bullet():
	spawning_bullet = true
	var bullet_instance = bullet.instantiate()
	var bullet_size = 8+(diff*2)
	bullet_instance.scale.x = bullet_size
	bullet_instance.scale.y = bullet_size
	bullet_instance.position.x = rng.randi_range(10,get_viewport_rect().size.x - 10)
	get_node("bullets").add_child(bullet_instance)
	var intensity = snapped(data[data_index]["intensity"],0.1)
	await get_tree().create_timer(max(1-((intensity+diff)*2)/10,0.1)).timeout
	spawning_bullet = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if MusicPlayer.get_playback_position() >= data[data_index]["end_time"]:
		var intensity = snapped(data[data_index]["intensity"],0.1)
		data_index += 1
		$bullets.speed = min_speed + intensity*200*diff
	if MusicPlayer.get_playback_position() >= data[len(data)-1]["end_time"]:
		data_index = len(data)-1
	
	if not spawning_bullet:
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
	MusicPlayer.play()
	spawning_bullet = true
	for bullet in get_node("bullets").get_children():
		bullet.queue_free()
	$GameOver.visible = false
	dead = false
	score = 0
	data_index=0
	rng.set_seed(1)
	rng.set_state(1)
	
func dying():
	if not 1:
		dead = true
		MusicPlayer.stop()
		$GameOver.visible = true
		$player/PointLight2D.texture_scale = 10

func _on_left_button_down():
	$player.direction = -1
func _on_left_button_up():
	$player.direction = 0
func _on_right_button_down():
	$player.direction = 1
func _on_right_button_up():
	$player.direction = 0


func _on_music_player_finished():
	var file = FileAccess.open("user://aventure.txt", FileAccess.WRITE_READ)
	file.store_line(JSON.stringify({"unlocked_levels":level_nbr+1}))
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")


func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
