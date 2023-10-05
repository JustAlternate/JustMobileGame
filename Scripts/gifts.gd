extends Node2D

var gift_list:Array
var speed:int = 200

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    gift_list = get_children()
    for gift in gift_list:
        gift.position.y += speed * delta
        if gift.position.y > get_viewport_rect().size.y:
            gift.queue_free()
            get_parent().nbr_powerups +=1
    
