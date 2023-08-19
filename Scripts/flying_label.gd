extends Label

var speed = 20
var color = Color(255,255,255)

# Called when the node enters the scene tree for the first time.
func _ready():
	label_settings = preload("res://Scenes/flyinglabelsetting.tres")
	label_settings.font_size = 16
	label_settings.font_color = color
	position.x = get_parent().get_node("player").position.x
	position.y = get_parent().get_node("player").position.y

func kill():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta
