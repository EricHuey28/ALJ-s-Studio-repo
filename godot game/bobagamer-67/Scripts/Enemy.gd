extends CharacterBody2D

enum State { PATROL, CHASE, SEARCH }
var current_state = State.PATROL

@export var speed = 150.0
@export var detection_radius = 250.0

var target_player = null
var patrol_point = Vector2.ZERO

func _ready():
	set_new_patrol_point()

func _physics_process(delta):
	match current_state:
		State.PATROL:
			patrol_behavior()
		State.CHASE:
			chase_behavior()
	
	check_for_player()
	move_and_slide()

func patrol_behavior():
	if global_position.distance_to(patrol_point) < 20:
		set_new_patrol_point()
	
	velocity = (patrol_point - global_position).normalized() * (speed * 0.5)
	rotation = lerp_angle(rotation, velocity.angle(), 0.1)

func chase_behavior():
	if target_player:
		velocity = (target_player.global_position - global_position).normalized() * speed
		rotation = lerp_angle(rotation, velocity.angle(), 0.1)
		
		# Relentless: They don't give up easily once they see you
		if global_position.distance_to(target_player.global_position) > 500:
			current_state = State.PATROL

func check_for_player():
	# Simple proximity check for the prototype
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var p = players[0]
		var dist = global_position.distance_to(p.global_position)
		
		# Stealth Pillar: Crouching reduces detection radius
		var effective_radius = detection_radius
		if p.has_method("is_crouching") and p.is_crouching():
			effective_radius *= 0.5
		
		if dist < effective_radius:
			if current_state != State.CHASE:
				print("Detected! Chase started.")
				current_state = State.CHASE
				target_player = p

func set_new_patrol_point():
	patrol_point = global_position + Vector2(randf_range(-200, 200), randf_range(-200, 200))

func die():
	print("Enemy eliminated.")
	queue_free()
