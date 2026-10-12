extends CharacterBody3D

enum State { IDLE, MOVING }

@export var speed: float = 3.0
@export var detect_range: float = 20.0
@export var stop_distance: float = 1.5
@export var turn_speed: float = 8.0

const GRAVITY: float = 9.8

var state: State = State.IDLE
var player: Node3D

@onready var mob = %mob

@onready var anim: AnimationPlayer = mob.find_child("AnimationPlayer", true, false)


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	_update_state()

	match state:
		State.IDLE:
			_idle_state()
		State.MOVING:
			_moving_state(delta)

	move_and_slide()

func _update_state() -> void:
	if player == null:
		_change_state(State.IDLE)
		return

	var to_player: Vector3 = player.global_position - global_position
	to_player.y = 0.0
	var distance: float = to_player.length()

	if distance < detect_range and distance > stop_distance:
		_change_state(State.MOVING)
	else:
		_change_state(State.IDLE)

func _change_state(new_state: State) -> void:
	if new_state == state:
		return
	state = new_state
	# Hook for animations, e.g.:
	# match state:
	#     State.IDLE: $AnimationPlayer.play("idle")
	#     State.MOVING: $AnimationPlayer.play("walk")

func _idle_state() -> void:
	velocity.x = 0.0
	velocity.z = 0.0
	if anim.current_animation != "idle":
		anim.play("idle")

func _moving_state(delta: float) -> void:
	var direction: Vector3 = player.global_position - global_position
	direction.y = 0.0
	direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	if anim.current_animation != "RUN":
		anim.play("RUN")
	var target_angle: float = atan2(-direction.x, -direction.z) + PI
	rotation.y = lerp_angle(rotation.y, target_angle, turn_speed * delta)




func _on_timer_timeout():
	queue_free()
