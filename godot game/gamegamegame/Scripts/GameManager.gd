extends Node

var money: int = 0
var day: int = 1
var current_phase: String = "SHOP" # "SHOP" or "MISSION"
var target_order_received: bool = false

# Player stats
var health: int = 100
var max_health: int = 100

# Inventory
var unlocked_weapons: Array = ["Pistol"]
var current_weapon: String = "Pistol"
var player_damage_multiplier: float = 1.0

func _ready():
	print("GameManager initialized")
	setup_inputs()

func setup_inputs():
	# Define our custom actions
	var actions = {
		"move_up": KEY_W,
		"move_down": KEY_S,
		"move_left": KEY_A,
		"move_right": KEY_D,
		"sprint": KEY_SHIFT,
		"crouch": KEY_CTRL,
		"weapon_1": KEY_1,
		"weapon_2": KEY_2,
		"ability": KEY_G
	}
	
	for action in actions:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var ev = InputEventKey.new()
			ev.physical_keycode = actions[action]
			InputMap.action_add_event(action, ev)
			
	# Mouse inputs
	if not InputMap.has_action("aim"):
		InputMap.add_action("aim")
		var ev_aim = InputEventMouseButton.new()
		ev_aim.button_index = MOUSE_BUTTON_RIGHT
		InputMap.action_add_event("aim", ev_aim)


func add_money(amount: int):
	money += amount
	print("Money added: ", amount, " | Total: ", money)

func start_mission():
	current_phase = "MISSION"
	target_order_received = false
	print("Starting Mission Phase...")
	# In a real scenario, we would change scenes here
	# get_tree().change_scene_to_file("res://Scenes/MissionScene.tscn")

func start_shop():
	current_phase = "SHOP"
	day += 1
	print("Starting Shop Phase - Day ", day)
	# get_tree().change_scene_to_file("res://Scenes/ShopScene.tscn")
