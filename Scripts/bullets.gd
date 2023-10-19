extends Node2D

var bullet_list:Array
var speed:float = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bullet_list = get_children()
	for bullet in bullet_list:
		bullet.position.y += speed * delta
		if bullet.position.y > get_viewport_rect().size.y:
			bullet.queue_free()
			get_parent().nbr_dodges +=1
	
