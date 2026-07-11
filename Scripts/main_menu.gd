extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/game/level1.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
	
	



func _on_settings_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/misc/settings.tscn") # Replace with function body.
