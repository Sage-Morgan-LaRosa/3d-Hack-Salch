extends AnimationPlayer
@onready var animation_player = $AnimationPlayer # Adjust path to your node

func _ready() -> void:
	animation_player.play("RUN")
