extends Node

signal difficulty_changed(difficulty)

const JSONFileParser = preload("res://Objects/json_file_parser.gd")
@onready var json_file_parser: JSONFileParser = JSONFileParser.new()
var master_audio_bus_idx = AudioServer.get_bus_index("Master")
var available_difficulties = [
	{
		"name": "Easy",
		"enemy_spawn_time": 2.0
	}, 
	{
		"name":"Medium",
		"enemy_spawn_time": 1.0
	}, 
	{
		"name": "Hard",
		"enemy_spawn_time": 0.5
	}]
var available_resolutions = ["1920x1080", "1366x768", "1280x720", "1024x768", "800x600", "640x480"]
# Default Settings
var settings: Dictionary = {
	"master_volume": AudioServer.get_bus_volume_db(master_audio_bus_idx),
	"fullscreen": false,
	"resolution_x": 1920,
	"resolution_y": 1080,
	"difficulty": available_difficulties[1]
}
var file_path = "user://settings.json"

func _ready():
	var json: JSON = json_file_parser.json_from_file(file_path)
	var data = json.data
	if(data == null || typeof(data) != TYPE_DICTIONARY):
		json_file_parser.json_to_file(file_path, settings)
		return
	if !validate_settings(data):
		json_file_parser.json_to_file(file_path, settings)
		return
	settings = data

func save_settings():
	difficulty_changed.emit(settings.difficulty)
	json_file_parser.json_to_file(file_path, settings)

func validate_settings(settings_dict: Dictionary) -> bool:
	if (!settings_dict.has("master_volume") || !settings_dict.has("fullscreen") || !settings_dict.has("resolution_x") || 
	!settings_dict.has("resolution_y") || !settings_dict.has("difficulty")):
		return false
	var master_volume = settings_dict["master_volume"]
	var fullscreen = settings_dict["fullscreen"]
	var resolution_x = int(settings_dict["resolution_x"])
	var resolution_y = int(settings_dict["resolution_y"])
	var difficulty = settings_dict["difficulty"]
	if(master_volume == null || typeof(master_volume) != TYPE_FLOAT || master_volume < -80.0 || master_volume > 0):
		return false
	if(fullscreen == null || typeof(fullscreen) != TYPE_BOOL):
		return false
	if(resolution_x == null || typeof(resolution_x) != TYPE_INT):
		return false
	if(resolution_y == null || typeof(resolution_y) != TYPE_INT):
		return false
	var res_arr: PackedStringArray = [resolution_x, resolution_y]
	if(!available_resolutions.has("x".join(res_arr))):
		return false
	if(difficulty == null || typeof(difficulty) != TYPE_DICTIONARY || !available_difficulties.has(difficulty) ||
	!difficulty.has("name") || !difficulty.has("enemy_spawn_time")):
		return false
	return true
