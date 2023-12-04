extends Node

func json_from_file(filepath: String) -> JSON:
	var json = JSON.new()
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file == null:
		print("No such file at ", filepath)
		return json
	var file_content = file.get_as_text()
	var error = json.parse(file_content)
	if error == OK:
		return json
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", file_content, " at line ", json.get_error_line())
		return json

func json_to_file(filepath: String, file_content) -> void:
	var file: FileAccess = FileAccess.open(filepath, FileAccess.WRITE)
	file.store_string(JSON.stringify(file_content))
