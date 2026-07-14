extends Node2D

@onready var anim_player = $Camera2D/AnimationPlayer

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/game/level1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _on_settings_button_up() -> void:
	anim_player.play("move_left")


func _on_back_pressed() -> void:
	anim_player.play("move_right")
