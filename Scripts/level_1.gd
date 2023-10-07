extends Node2D

var score = 0
var nbr_dodges = 0
var nbr_powerups = 0
const bullet = preload("res://Scenes/bullet.tscn")
const player = preload("res://Scenes/player.tscn")
const gift = preload("res://Scenes/gift.tscn")
const flying_label_script = preload("res://Scripts/flying_label.gd")
var player_instance = player.instantiate()
var time_before_next_bullet_spawn:float = 0.1
var spawning_bullet = false
var dead = false

var json_as_text = FileAccess.get_file_as_string("res://Assets/output.json" )
var data = JSON.parse_string(json_as_text)
var data_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    seed(1)
    $MusicPlayer.play()
    add_child(player_instance)
    $CanvasModulate.visible = true
    $bullets.speed = snapped(data[0]["intensity"],0.1) * 300

func spawn_bullet():
    spawning_bullet = true
    var bullet_instance = bullet.instantiate()
    var bullet_size = 8+(snapped(data[data_index]["intensity"],0.1)*5)
    bullet_instance.scale.x = bullet_size
    bullet_instance.scale.y = bullet_size
    bullet_instance.position.x = randi_range(10,get_viewport_rect().size.x - 10)
    get_node("bullets").add_child(bullet_instance)
    await get_tree().create_timer(0.6 - snapped(data[data_index]["intensity"],0.1)/10).timeout
    spawning_bullet = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if $MusicPlayer.get_playback_position() > data[data_index]["end_time"]:
        data_index += 1
        $bullets.speed = snapped(data[data_index]["intensity"],0.1) * 300
    
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
    $MusicPlayer.play()
    spawning_bullet = true
    for bullet in get_node("bullets").get_children():
        bullet.queue_free()
    $GameOver.visible = false
    time_before_next_bullet_spawn = 0.7
    $player.scale = Vector2(3,3)
    $bullets.speed = 200
    $gifts.speed = 200
    dead = false
    score = 0
    data_index=0
    $player/PointLight2D.texture_scale = 3

func dying():
    if not dead:
        dead = true
        $MusicPlayer.stop()
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
    get_tree().change_scene_to_file("res://Scenes/Menu.tscn")


func _on_back_to_menu_pressed():
    get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
