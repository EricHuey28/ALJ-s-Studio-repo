extends CharacterBody2D

var speed = 200
var sprint_speed = 350
var crouch_speed = 100
var aim_speed_penalty = 0.5
var health = 100

var is_crouching = false
var is_aiming = false

# Weapon State
var current_weapon_idx = 1 # 1 = Main, 2 = Melee

var fire_cooldown = 0.0

@export var projectile_scene: PackedScene

func _physics_process(delta):
	if fire_cooldown > 0:
		fire_cooldown -= delta
	update_trail()
	if has_node("Visuals"):
		$Visuals.look_at(get_global_mouse_position())

func update_trail():
	if has_node("Trail"):
		var trail = $Trail
		trail.add_point(global_position)
		if trail.points.size() > 15:
			trail.remove_point(0)
	
	handle_state_inputs()
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var current_speed = speed
	
	if is_crouching:
		current_speed = crouch_speed
	elif Input.is_action_pressed("sprint") and not is_aiming:
		current_speed = sprint_speed
		
	if is_aiming:
		current_speed *= aim_speed_penalty
		
	velocity = direction * current_speed
	
	if velocity.length() > 0:
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("walk")
	else:
		if has_node("AnimationPlayer"):
			$AnimationPlayer.stop()
			$Visuals.scale = Vector2(1, 1)
		
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if fire_cooldown <= 0:
			attack()

func handle_state_inputs():
	# Crouch
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		if not has_node("AnimationPlayer") or not $AnimationPlayer.is_playing():
			$Visuals.scale = Vector2(0.8, 0.8) # Visual feedback for crouch
	else:
		is_crouching = false
		if not has_node("AnimationPlayer") or not $AnimationPlayer.is_playing():
			$Visuals.scale = Vector2(1, 1)

	# Aim
	if Input.is_action_pressed("aim"):
		is_aiming = true
	else:
		is_aiming = false

	# Weapon Switching
	if Input.is_action_just_pressed("weapon_1"):
		switch_weapon(1)
	elif Input.is_action_just_pressed("weapon_2"):
		switch_weapon(2)
	elif Input.is_action_just_pressed("weapon_3") if InputMap.has_action("weapon_3") else Input.is_key_pressed(KEY_3):
		switch_weapon(3)

func switch_weapon(idx):
	current_weapon_idx = idx
	print("Switched to weapon ", idx)
	update_hotbar_ui()

func update_hotbar_ui():
	# Find Hotbar in the scene (usually in UI_Layer)
	var hotbar = get_tree().current_scene.find_child("Hotbar", true, false)
	if hotbar:
		var hbox = hotbar.get_node("HBox")
		for i in range(hbox.get_child_count()):
			var slot = hbox.get_child(i)
			var style = slot.get_theme_stylebox("panel").duplicate()
			if i + 1 == current_weapon_idx:
				style.bg_color = Color(0.4, 0.7, 1, 0.5)
				style.border_color = Color(0.4, 0.7, 1, 1)
			else:
				style.bg_color = Color(0, 0, 0, 0.5)
				style.border_color = Color(0, 0, 0, 0)
			slot.add_theme_stylebox_override("panel", style)

func use_ability():
	print("Ability Used! (G)")
	# Placeholder: Dash or Special Effect
	var dash_dir = velocity.normalized()
	if dash_dir == Vector2.ZERO:
		dash_dir = Vector2.RIGHT.rotated($Visuals.rotation)
	position += dash_dir * 100

func attack():
	if current_weapon_idx == 1:
		shoot()
	else:
		melee_attack()

func melee_attack():
	print("Melee Attack!")
	var enemies_node = get_parent().get_node_or_null("Enemies")
	if enemies_node:
		for enemy in enemies_node.get_children():
			if enemy.has_method("take_damage"):
				var dist = global_position.distance_to(enemy.global_position)
				if dist < 80: # Melee range
					# Check angle (must be roughly in front)
					var dir_to_enemy = global_position.direction_to(enemy.global_position)
					var facing_dir = Vector2.RIGHT.rotated($Visuals.rotation)
					if facing_dir.dot(dir_to_enemy) > 0.5: # ~60 degrees cone
						enemy.take_damage(20 * GameManager.player_damage_multiplier)
						print("Hit enemy with melee!")

func shoot():
	if projectile_scene:
		# Base cooldown is 1.0s, reduced by 0.2s for every 0.5 increment in multiplier
		# Multiplier starts at 1.0. (1.0 - 1.0) * 0.4 = 0.
		var rate_bonus = (GameManager.player_damage_multiplier - 1.0) * 0.4
		fire_cooldown = max(0.1, 1.0 - rate_bonus)
		
		var p = projectile_scene.instantiate()
		p.position = position
		p.direction = Vector2.RIGHT.rotated($Visuals.rotation)
		p.rotation = $Visuals.rotation
		get_parent().add_child(p)

func take_damage(amount):
	health -= amount
	if has_node("HealthBar"):
		$HealthBar.value = health
	print("Player Health: ", health)
	if health <= 0:
		get_tree().reload_current_scene() # Restart level on death
