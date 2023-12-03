extends VBoxContainer

signal options_closed

@onready var volume_slider: HSlider = $VolumeSlider
@onready var fullscreen_toggle: CheckBox = $FullscreenToggle
var main_audio_bus_idx = AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready():
	var volume: float = Settings.settings["master_volume"]
	var fullscreen: bool = Settings.settings["fullscreen"]
	volume_slider.value = volume
	fullscreen_toggle.button_pressed = fullscreen
	set_volume(volume)
	toggle_fullscreen(fullscreen)

func set_volume(volume: float):
	AudioServer.set_bus_volume_db(main_audio_bus_idx, volume)

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
	Settings.settings["master_volume"] = volume_slider.value
	Settings.settings["fullscreen"] = fullscreen_toggle.button_pressed
	Settings.save_settings()
	options_closed.emit()
