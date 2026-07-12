extends Node2D

# Grab the nodes using their new names and the tree path
@onready var master_slider = $CenterContainer/MarginContainer/VBoxContainer/GridContainer/MasterSlider
@onready var music_slider = $CenterContainer/MarginContainer/VBoxContainer/GridContainer/MusicSlider
@onready var ui_slider = $CenterContainer/MarginContainer/VBoxContainer/GridContainer/UISlider
@onready var sfx_slider = $CenterContainer/MarginContainer/VBoxContainer/GridContainer/SFXSlider
@onready var back_button = $CenterContainer/MarginContainer/VBoxContainer/Back

const SETTINGS_FILE = "user://settings.cfg"

func _ready():
	# Connect the sliders to functions when the scene loads
	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	ui_slider.value_changed.connect(_on_ui_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	back_button.pressed.connect(_on_back_pressed)
	
	# Load what they saved last time
	load_settings()

func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_FILE)
	
	if err == OK:
		master_slider.value = config.get_value("audio", "master_volume", 0.0)
		music_slider.value = config.get_value("audio", "music_volume", 0.0)
		ui_slider.value = config.get_value("audio", "ui_volume", 0.0)
		sfx_slider.value = config.get_value("audio", "sfx_volume", 0.0)
		
	# Push the loaded values to the actual game audio
	_apply_volume("Master", master_slider.value)
	_apply_volume("Music", music_slider.value)
	_apply_volume("SFX", sfx_slider.value)
	_apply_volume("UI", ui_slider.value)

func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_slider.value)
	config.set_value("audio", "music_volume", music_slider.value)
	config.set_value("audio", "ui_volume", ui_slider.value)
	config.set_value("audio", "sfx_volume", sfx_slider.value)
	config.save(SETTINGS_FILE)

# --- These trigger every time you drag a slider ---

func _on_master_changed(value): _apply_volume("Master", value); save_settings()
func _on_music_changed(value): _apply_volume("Music", value); save_settings()
func _on_ui_changed(value): _apply_volume("UI", value); save_settings()
func _on_sfx_changed(value): _apply_volume("SFX", value); save_settings()

func _on_back_pressed():
	# TODO: Change this line to go back to your main settings menu!
	# Example: get_tree().change_scene_to_file("res://main_settings_menu.tscn")
	queue_free() # For now, this just closes the crosshair menu

# --- The magic function that talks to Godot's audio engine ---

func _apply_volume(bus_name: String, value: float):
	var bus_idx = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_idx, value)
