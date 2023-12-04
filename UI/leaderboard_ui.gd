extends CanvasLayer

signal leaderboard_closed

const Score = preload("res://Objects/score.gd")
const SubtitleTheme = preload("res://themes/subtitle_theme.tres")
@onready var scores: Array = Leaderboard.scores
@onready var no_scores_rect: CenterContainer = $NoScoreContainer
@onready var score_container: ScrollContainer = $ScoreContainer
@onready var score_grid_container: GridContainer = $ScoreContainer/ScoreGridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Leaderboard.scores_changed.connect(_reload_scores)
	no_scores_rect.visible = scores.size() == 0
	score_container.visible = scores.size() > 0
	_load_scores()

func _load_scores():
	for score in scores:
		var username_label: Label = _username_label(score.username)
		var user_score: Label = _user_score(score.score)
		score_grid_container.add_child(username_label)
		score_grid_container.add_child(user_score)

func _reload_scores():
	for n in score_grid_container.get_children():
		score_grid_container.remove_child(n)
		n.queue_free()
	scores = Leaderboard.scores
	_load_scores()

func _grid_label(text: String) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.theme = SubtitleTheme
	label.custom_minimum_size = Vector2(230, 0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label

func _username_label(username: String) -> Label:
	return _grid_label(username)

func _user_score(user_score: int) -> Label:
	return _grid_label(str(user_score))

func _on_go_back_button_pressed():
	leaderboard_closed.emit()
