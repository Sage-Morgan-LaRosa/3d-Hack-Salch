extends RigidBody3D


var health = 3
var speed = randf_range(4.0, 8.0)

@onready var mob = %mob
@onready var timer = %Timer

@onready var player = get_node("/root/Main/Player")


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	linear_velocity = direction * speed
	direction.y = 0.0
	mob.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI


func take_damage():
	if health <= 0:
		return

	mob.hurt()

	health -= 1

	if health == 0:
		set_physics_process(false)
		var direction = player.global_position.direction_to(global_position)
		var random_upward_force = Vector3.UP * randf() * 5.0
		timer.start()


func _on_timer_timeout():
	queue_free()
