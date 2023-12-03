extends CanvasLayer

signal restart_button_pressed
signal resume_button_pressed

func _on_resume_button_pressed():
	resume_button_pressed.emit()

func _on_restart_button_pressed():
	restart_button_pressed.emit()
