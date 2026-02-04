extends CharacterBody2D

var speed = 100
var player = null
var health = 30

func _ready():
	# Find player in scene
	player = get_parent().get_node_or_null("Player")

func _physics_process(delta):
	if player:
		var dist = position.distance_to(player.position)
		var detection_range = 300
		
		# Check if player has the property is_crouching
		if "is_crouching" in player and player.is_crouching:
			detection_range = 150 # Reduced range for stealth
		
		if dist < detection_range: # Aggro range
			look_at(player.position)
			# Simple chase
			velocity = position.direction_to(player.position) * speed
		else:
			velocity = Vector2.ZERO
			
	move_and_slide()
	
	if player:
		var dist = position.distance_to(player.position)
		if dist < 40: # Melee damage range check
			if player.has_method("take_damage"):
				# Simple cooldown check could go here
				pass

func take_damage(amount):
	health -= amount
	if has_node("HealthBar"):
		$HealthBar.value = health
	if health <= 0:
		die()

func die():
	print("Enemy eliminated")
	queue_free()
