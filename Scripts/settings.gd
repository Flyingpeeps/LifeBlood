extends Node2D

# Node paths to the sliders
@onready var master_slider = $CenterContainer/MarginContainer/VBoxContainer/GridContainer/MasterSlider
@onready var music_slider = $CenterContainer/MarginContainer/VBoxContainer/GridContainer/MusicSlider
@onready var ui_slider = $CenterContainer/MarginContainer/VBoxContainer/GridContainer/UISlider
@onready var sfx_slider = $CenterContainer/MarginContainer/VBoxContainer/GridContainer/SFXSlider
@onready var back_button = $CenterContainer/MarginContainer/VBoxContainer/Back

const SETTINGS_FILE = "user://settings.cfg" # Location of saved configgurations

func _ready() -> void:
	# Connect signals to functions when the scene loads
	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	ui_slider.value_changed.connect(_on_ui_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	back_button.pressed.connect(_on_back_pressed)
	
	load_settings() # Load settings from settings.cfg

func load_settings() -> void:
	var config = ConfigFile.new() # Create a new config file object
	var err = config.load(SETTINGS_FILE)
	
	if err == OK: # If the file loaded successfully, grab the values
		master_slider.value = config.get_value("audio", "master_volume", 0.0)
		music_slider.value = config.get_value("audio", "music_volume", 0.0)
		ui_slider.value = config.get_value("audio", "ui_volume", 0.0)
		sfx_slider.value = config.get_value("audio", "sfx_volume", 0.0)
		
	# Push the payload to the audio engine
	_apply_volume("Master", master_slider.value)
	_apply_volume("Music", music_slider.value)
	_apply_volume("SFX", sfx_slider.value)
	_apply_volume("UI", ui_slider.value)

func save_settings() -> void:
	var config = ConfigFile.new() # Creates new config file object
	config.set_value("audio", "master_volume", master_slider.value)
	config.set_value("audio", "music_volume", music_slider.value)
	config.set_value("audio", "ui_volume", ui_slider.value)
	config.set_value("audio", "sfx_volume", sfx_slider.value)
	config.save(SETTINGS_FILE) # Write changes to disk

# Uses functions to automatically save whichever changes were made after any changes are made
func _on_master_changed(value): _apply_volume("Master", value); save_settings()
func _on_music_changed(value): _apply_volume("Music", value); save_settings()
func _on_ui_changed(value): _apply_volume("UI", value); save_settings()
func _on_sfx_changed(value): _apply_volume("SFX", value); save_settings()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/misc/main_menu.tscn") # Go back to the game

# Function for comminucation with audio engggine
func _apply_volume(bus_name: String, value: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name) # Find the bus index by name
	AudioServer.set_bus_volume_db(bus_idx, value) # Set the volume in decibels
