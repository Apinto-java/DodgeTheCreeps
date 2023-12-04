extends CanvasLayer

signal start_game

@onready var buttons = $ButtonContainer
@onready var game_hud = $GameHUD
@onready var options = $OptionsMenu
@onready var pause_menu = $PauseMenu
@onready var leaderboard_ui = $Leaderboard_UI
@onready var score_confirmation = $Score_Confirmation
var can_pause: bool = false

func _ready():
	game_hud.get_node("ScoreLabel").visible = false

func _process(delta):
	if Input.is_action_just_pressed("pause") && can_pause:
		pause_and_unpause()

func pause_and_unpause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	buttons.visible = get_tree().paused
	buttons.get_node("StartButton").visible = !get_tree().paused
	buttons.get_node("LeaderboardButton").visible = !get_tree().paused

func _on_resume_button_pressed():
	pause_and_unpause()

func show_message(text: String):
	game_hud.show_message(text)

func show_game_over(final_score: int):
	game_hud.show_game_over()
	game_hud.get_node("ScoreLabel").visible = false
	score_confirmation.score = final_score
	score_confirmation.show()

func _on_score_confirmed():
	score_confirmation.hide()
	buttons.show()

func update_score(score):
	game_hud.update_score(score)

func show_score():
	game_hud.get_node("ScoreLabel").visible = true

func _on_start_button_pressed():
	buttons.hide()
	start_game.emit()

func _on_pause_menu_restart_button_pressed():
	pause_and_unpause()
	_on_start_button_pressed()

func _on_options_button_pressed():
	buttons.hide()
	game_hud.hide()
	pause_menu.hide()
	options.show()

func _on_options_menu_options_closed():
	options.hide()
	buttons.show()
	pause_menu.visible = get_tree().paused
	game_hud.show()

func _on_exit_button_pressed():
	get_tree().quit()

func _can_pause_changed(can_pause_value):
	can_pause = can_pause_value

func _on_leaderboard_pressed():
	buttons.hide()
	game_hud.hide()
	leaderboard_ui.show()

func _on_leaderboard_closed():
	leaderboard_ui.hide()
	buttons.show()
	game_hud.show()
