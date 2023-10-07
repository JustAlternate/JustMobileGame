extends CharacterBody2D

var speed = 2
var angle = -(3*PI)/2
var radius = 190
var direction:int = 0

func _ready():
    var speed = 2
    var angle = -(3*PI)/2
    var radius = 190
    var direction:int = 0
    position.x = 208 + radius * cos(angle) 
    position.y = 600 + radius * sin(angle)

func _process(delta):
    if direction == -1 and position.x > 15*scale.x :
        angle += speed * delta
    elif direction == 1 and position.x < get_viewport_rect().size.x - 15*scale.x : #RIGHT
        angle -= speed * delta
    if direction != 0:
        position.x = 208 + radius * cos(angle) 
        position.y = 600 + radius * sin(angle)
