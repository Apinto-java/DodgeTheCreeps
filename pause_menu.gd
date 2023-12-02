extends CanvasLayer

@onready var options_menu: VBoxContainer = $OptionsMenu
@onready var volume_slider: HSlider = $OptionsMenu/VolumeSlider
@onready var main_audio_bus_idx = AudioServer.get_bus_index("Master")

var can_pause: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_slider.value = AudioServer.get_bus_volume_db(main_audio_bus_idx)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") && can_pause:
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(main_audio_bus_idx, value)


func _on_options_button_pressed():
	options_menu.show()

func close_options_menu():
	options_menu.hide()


func _on_main_can_pause_changed(can_pause_value):
	can_pause = can_pause_value


func _on_resume_button_pressed():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
