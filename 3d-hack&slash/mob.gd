extends RigidBody3D


var speed = randf_range(4.0, 8.0)

@onready var mob = %mob
@onready var timer = %Timer


@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	linear_velocity = direction * speed
	direction.y = 0.0
	mob.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI



func _on_timer_timeout():
	queue_free()
