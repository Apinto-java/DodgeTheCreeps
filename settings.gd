extends Node

var master_audio_bus_idx = AudioServer.get_bus_index("Master")
var settings: Dictionary = {}
var file_path = "user://settings.json"

func _ready():
	load_from_file()

func save_settings():
	var settingsFile = FileAccess.open(file_path, FileAccess.WRITE)
	settingsFile.store_string(JSON.stringify(settings))

func load_from_file():
	var settings_file = FileAccess.open(file_path, FileAccess.READ)
	if settings_file == null:
		load_default_settings_and_save()
		return
	var settings_file_content = settings_file.get_as_text()
	var settings_json = JSON.new()
	var error = settings_json.parse(settings_file_content)
	if error == OK:
		var data_received = settings_json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			settings = data_received
			validate_settings()
		else:
			print("Unexpected data")
			load_default_settings_and_save()
	else:
		print("JSON Parse Error: ", settings_json.get_error_message(), " in ", settings_file_content, " at line ", settings_json.get_error_line())
		load_default_settings_and_save()

func validate_settings():
	if(!settings.has("master_volume") || !settings.has("fullscreen")):
		load_default_settings_and_save()
		return
	var master_volume = settings["master_volume"]
	var fullscreen = settings["fullscreen"]
	if(master_volume == null || typeof(master_volume) != TYPE_FLOAT || master_volume < -80.0 || master_volume > 0):
		load_default_settings_and_save()
		return
	if(fullscreen == null || typeof(fullscreen) != TYPE_BOOL):
		load_default_settings_and_save()
		return

func load_default_settings_and_save():
	load_default_settings()
	save_settings()

func load_default_settings():
	settings = {
		"master_volume": AudioServer.get_bus_volume_db(master_audio_bus_idx),
		"fullscreen": false
	}
