extends VBoxContainer

signal options_closed

@onready var volume_slider: HSlider = $VolumeSlider
@onready var fullscreen_toggle: CheckBox = $FullscreenToggle
@onready var resolution_options: OptionButton = $ResolutionsList
var main_audio_bus_idx = AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready():
	var volume: float = Settings.settings.master_volume
	var fullscreen: bool = Settings.settings.fullscreen
	var res_x: int = Settings.settings.resolution_x
	var res_y: int = Settings.settings.resolution_y
	volume_slider.value = volume
	fullscreen_toggle.button_pressed = fullscreen
	load_resolutions()
	set_volume(volume)
	toggle_fullscreen(fullscreen)

func load_resolutions():
	# Loop through the available resolutions array, parse the resolutions, 
	# if it's valid, add it to the list and check if the x and y corresponds
	# to the current selected resolution
	var idx = 0
	for res: String in Settings.available_resolutions:
		var res_vector = parse_resolution_text(res)
		if(res_vector == Vector2i.ZERO):
			continue
		resolution_options.add_item(res, idx)
		if(res_vector.x == Settings.settings.resolution_x && res_vector.y == Settings.settings.resolution_y):
			resolution_options.select(idx)
			set_resolution(res_vector)
		idx += 1

# Takes a string as a parameter and returns a Vector2i.
# Returns Vector2i.ZERO if the input is not a valid
# resolution
func parse_resolution_text(res_text: String):
	var res_vector = Vector2i.ZERO
	var res_arr = res_text.split("x")
	if(res_arr.size() != 2):
		return res_vector
	
	res_vector.x = int(res_arr[0])
	res_vector.y = int(res_arr[1])
	return res_vector

func set_volume(volume: float):
	AudioServer.set_bus_volume_db(main_audio_bus_idx, volume)

func set_resolution(res: Vector2i):
	if(res != Vector2i.ZERO):
		DisplayServer.window_set_size(res)

func toggle_fullscreen(toggle: bool):
	if(toggle):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_cancel_button_pressed():
	options_closed.emit()

func _on_accept_button_pressed():
	set_volume(volume_slider.value)
	toggle_fullscreen(fullscreen_toggle.button_pressed)
	var res_vector = parse_resolution_text(resolution_options.get_item_text(resolution_options.selected))
	set_resolution(res_vector)
	Settings.settings["master_volume"] = volume_slider.value
	Settings.settings["fullscreen"] = fullscreen_toggle.button_pressed
	if(res_vector != Vector2i.ZERO):
		Settings.settings.resolution_x = res_vector.x
		Settings.settings.resolution_y = res_vector.y
	Settings.save_settings()
	options_closed.emit()
