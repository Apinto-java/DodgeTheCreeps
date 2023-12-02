extends Node
@export var mob_scene: PackedScene
@onready var start_timer: Timer = $StartTimer
@onready var score_timer: Timer = $ScoreTimer
@onready var mob_timer: Timer = $MobTimer
@onready var hud = $HUD
@onready var player = $Player
@onready var start_position: Marker2D = $StartPosition
@onready var music = $Music
@onready var death_sound = $DeathSound
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	score_timer.stop()
	mob_timer.stop()
	hud.show_game_over()
	music.stop()
	death_sound.play()

func new_game():
	score = 0
	player.start(start_position.position)
	start_timer.start()
	hud.update_score(score)
	hud.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	music.play()


func _on_start_timer_timeout():
	mob_timer.start()
	score_timer.start()


func _on_score_timer_timeout():
	score += 1
	hud.update_score(score)


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
