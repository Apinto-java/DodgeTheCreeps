extends CharacterBody2D

signal hit

@export var speed = 400
var screen_size

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = direction * speed
	
	move_and_slide()
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.length() > 0:
		animated_sprite.play()
	else:
		animated_sprite.stop()
	
	if velocity.x != 0:
		animated_sprite.animation = "walk"
		animated_sprite.flip_v = false
		animated_sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite.animation = "up"
		animated_sprite.flip_v = velocity.y > 0


func _on_body_entered(body):
	hide()
	hit.emit()
	collision_shape.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	collision_shape.disabled = false

