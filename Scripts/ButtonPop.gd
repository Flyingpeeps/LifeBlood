extends TextureButton

@export var hover_scale : Vector2 = Vector2(1.08, 1.08) # 8% pop
@export var default_scale : Vector2 = Vector2(1.0, 1.0) # Regular scale while unpopped
@export var tween_duration : float = 0.08 # Duration of pop

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered) 
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, tween_duration)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", default_scale, tween_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
