extends CanvasLayer

signal game_over_finished

@onready var message: Label = $Message
@onready var score_label: Label = $ScoreLabel
@onready var message_timer: Timer = $MessageTimer

func show_message(text: String):
	message.text = text
	message.show()
	message_timer.start()

func update_score(score):
	score_label.text = str(score)

func _on_message_timer_timeout():
	message.hide()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await message_timer.timeout
	
	message.text = "Dodge the Creeps!"
	message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	game_over_finished.emit()
