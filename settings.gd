extends Node

const JSONFileParser = preload("res://Objects/json_file_parser.gd")
@onready var json_file_parser: JSONFileParser = JSONFileParser.new()
var master_audio_bus_idx = AudioServer.get_bus_index("Master")
var settings: Dictionary = {
	"master_volume": AudioServer.get_bus_volume_db(master_audio_bus_idx),
	"fullscreen": false,
	"resolution_x": 1920,
	"resolution_y": 1080
}
var available_resolutions = ["1920x1080", "1366x768", "1280x720", "1024x768", "800x600", "640x480"]
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
	json_file_parser.json_to_file(file_path, settings)

func validate_settings(settings_dict: Dictionary) -> bool:
	if (!settings_dict.has("master_volume") || !settings_dict.has("fullscreen") || !settings_dict.has("resolution_x") || 
	!settings_dict.has("resolution_y")):
		return false
	var master_volume = settings["master_volume"]
	var fullscreen = settings["fullscreen"]
	var resolution_x = int(settings["resolution_x"])
	var resolution_y = int(settings["resolution_y"])
	if(master_volume == null || typeof(master_volume) != TYPE_FLOAT || master_volume < -80.0 || master_volume > 0):
		return false
	if(fullscreen == null || typeof(fullscreen) != TYPE_BOOL):
		return false
	if(resolution_x == null || typeof(resolution_x) != TYPE_INT):
		return false
	if(resolution_y == null || typeof(resolution_y) != TYPE_INT):
		return false
	return true
