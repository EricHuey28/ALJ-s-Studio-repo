extends CharacterBody2D

# Constants from GDD Verbs
const WALK_SPEED = 200.0
const RUN_SPEED = 350.0
const CROUCH_SPEED = 100.0

var current_weapon = 1 # 1: Main, 2: Melee
var health = 100

func _physics_process(_delta):
	handle_movement()
	handle_actions()
	move_and_slide()
	look_at(get_global_mouse_position())

func handle_movement():
	var speed = WALK_SPEED
	
	# [Shift] = Sprint, [Left Ctrl] = Crouch
	if Input.is_physical_key_pressed(KEY_SHIFT):
		speed = RUN_SPEED
	elif Input.is_physical_key_pressed(KEY_CTRL):
		speed = CROUCH_SPEED
	
	# [WASD] = Move
	var input_dir = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W): input_dir.y -= 1
	if Input.is_physical_key_pressed(KEY_S): input_dir.y += 1
	if Input.is_physical_key_pressed(KEY_A): input_dir.x -= 1
	if Input.is_physical_key_pressed(KEY_D): input_dir.x += 1
	
	velocity = input_dir.normalized() * speed

func handle_actions():
	# [1] = Main Weapon, [2] = Melee Weapon
	if Input.is_physical_key_pressed(KEY_1):
		current_weapon = 1
	elif Input.is_physical_key_pressed(KEY_2):
		current_weapon = 2
	
	# [G] = Ability
	if Input.is_physical_key_pressed(KEY_G):
		use_ability()
	
	# [Left Click] = Attack
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		attack()

func attack():
	# Placeholder for weapon-specific logic
	pass

func use_ability():
	# Placeholder for G ability
	pass
