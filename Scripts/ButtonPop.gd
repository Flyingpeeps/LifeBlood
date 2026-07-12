extends TextureButton

@export var hover_scale : Vector2 = Vector2(1.08, 1.08) # 8% pop
@export var pressed_scale : Vector2 = Vector2(0.95, 0.95) # Squish when pressed
@export var default_scale : Vector2 = Vector2(1.0, 1.0) # Regular scale while unpopped
@export var tween_duration : float = 0.08 # Duration of pop
@export var audio_player_path : NodePath # Audio player
@export var AudioDebug = false

const hitSound = preload("res://Assets/Sound/Effects/Hit.wav") # Preload sounds to avoid weird errors...?
const blingSound = preload("res://Assets/Sound/Effects/Hit.wav")
const boingSound = preload("res://Assets/Sound/Effects/inverted_boing.wav") 


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered) 
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, tween_duration)\
	.set_trans(Tween.TRANS_BACK)\
	.set_ease(Tween.EASE_OUT)
	
	var sound_node = get_node_or_null(audio_player_path)
	if sound_node: #Play loaded sound if audio stream player is valid
		sound_node.stream = hitSound
		sound_node.play() 
		
		if AudioDebug == true:
			print("A piece of audio has allegedly been played")


func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", default_scale, tween_duration)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_OUT)
		
	var sound_node = get_node_or_null(audio_player_path)
	
	if sound_node: #Play loaded sound if audio stream player is valid
		sound_node.stream = hitSound
		sound_node.play()
		
		if AudioDebug == true:
			print("A piece of audio has allegedly been played")


func _on_button_down() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", pressed_scale, tween_duration)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_OUT)
		
	var sound_node = get_node_or_null(audio_player_path)
	
	if sound_node: #Play loaded sound if audio stream player is valid
		sound_node.stream = boingSound
		sound_node.play()
		
		if AudioDebug == true:
			print("A piece of audio has allegedly been played")


func _on_button_up() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, tween_duration)\
	.set_trans(Tween.TRANS_BACK)\
	.set_ease(Tween.EASE_OUT)
		
	var sound_node = get_node_or_null(audio_player_path)
	
	if sound_node: #Play loaded sound if audio stream player is valid
		sound_node.stream = hitSound
		sound_node.play()
		
		if AudioDebug == true:
			print("A piece of audio has allegedly been played")
