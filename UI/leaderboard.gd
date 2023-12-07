extends Node

signal scores_changed

var scores: Array = []
var file_path = "user://leaderboard.json"
const JSONFileParser = preload("res://Objects/json_file_parser.gd")
@onready var json_file_parser: JSONFileParser = JSONFileParser.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var score_json: JSON = json_file_parser.json_from_file(file_path)
	var data = score_json.data
	if data == null || typeof(data) != TYPE_ARRAY:
		json_file_parser.json_to_file(file_path, scores)
		return
	data = data.filter(remove_invalid_score)
	scores = data

func add_score(score: Dictionary, save_file := false) -> void:
	scores.push_front(score)
	if save_file:
		save_scores()
	scores_changed.emit()

func save_scores() -> void:
	json_file_parser.json_to_file(file_path, scores)

func remove_invalid_score(score) -> bool:
	if typeof(score) != TYPE_DICTIONARY:
		return false
	var score_dict: Dictionary = score
	return _valid_username(score_dict) && _valid_score(score_dict) && _valid_difficulty(score_dict)

func _valid_username(score_dict: Dictionary) -> bool:
	return score_dict.has("username") && typeof(score_dict["username"]) == TYPE_STRING

func _valid_score(score_dict: Dictionary) -> bool:
	return score_dict.has("score") && (typeof(score_dict["score"]) == TYPE_INT || typeof(score_dict["score"]) == TYPE_FLOAT) && score_dict["score"] > 0

func _valid_difficulty(score_dict: Dictionary) -> bool:
	return score_dict.has("difficulty") && typeof(score_dict["difficulty"]) == TYPE_DICTIONARY && Settings.available_difficulties.has(score_dict["difficulty"])
