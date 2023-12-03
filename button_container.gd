extends VBoxContainer

signal start_game_pressed
signal options_menu_pressed
signal close_game_pressed

func _on_start_button_pressed():
	start_game_pressed.emit()

func _on_options_button_pressed():
	options_menu_pressed.emit()

func _on_exit_button_pressed():
	close_game_pressed.emit()
