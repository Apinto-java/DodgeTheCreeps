extends CenterContainer

signal score_confirmed
const Score = preload("res://Objects/score.gd")

@onready var text_edit: TextEdit = $ColorRect/VBoxContainer/TextEdit
var char_limit: int  = 6
var current_text: String = ""
var cursor_line:int = 0
var cursor_column:int = 0
var score: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_text_edit_text_changed():
	var new_text: String = text_edit.text
	if new_text.length() > char_limit:
		text_edit.text = current_text
		text_edit.set_caret_column(cursor_column)
		text_edit.set_caret_line(cursor_line)
	current_text = text_edit.text
	cursor_line = text_edit.get_caret_line()
	cursor_column = text_edit.get_caret_column()

func _on_button_pressed():
	var user_score: Dictionary = { "username": current_text, "score": score }
	Leaderboard.add_score(user_score, true)
	score_confirmed.emit()
	score = 0
