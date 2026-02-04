extends Control

var ingredients = ["Tea", "Milk", "Syrup", "Boba", "Ice"]
var current_order = []
var player_mix = []
var shift_time = 60.0 # Time limit for the day shift

@onready var order_display = $VBoxContainer/OrderLabel
@onready var mix_display = $VBoxContainer/MixLabel
@onready var feedback_display = $VBoxContainer/FeedbackLabel

func _ready():
	new_customer()

func _process(delta):
	shift_time -= delta
	if shift_time <= 0:
		end_shift()

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1: add_to_mix("Tea")
			KEY_2: add_to_mix("Milk")
			KEY_3: add_to_mix("Syrup")
			KEY_4: add_to_mix("Boba")
			KEY_5: add_to_mix("Ice")
			KEY_ENTER: serve_order()
			KEY_BACKSPACE: clear_mix()

func new_customer():
	player_mix.clear()
	current_order.clear()
	
	# Random order (2-4 ingredients)
	var size = randi_range(2, 4)
	for i in range(size):
		current_order.append(ingredients.pick_random())
	current_order.sort()
	
	# Chance for special contract order
	if randf() < 0.2:
		feedback_display.text = "SPECIAL CONTRACT ORDER DETECTED"
		feedback_display.modulate = Color(1, 0.5, 0)
	else:
		feedback_display.text = "A customer approaches."
		feedback_display.modulate = Color(1, 1, 1)
	
	update_ui()

func add_to_mix(item):
	player_mix.append(item)
	update_ui()

func clear_mix():
	player_mix.clear()
	update_ui()

func serve_order():
	player_mix.sort()
	if player_mix == current_order:
		handle_success()
	else:
		handle_failure()
	new_customer()

func handle_success():
	GameManager.add_cash(10)
	if feedback_display.text.contains("SPECIAL"):
		GameManager.set_contract("The Rogue Agent", 100)
		feedback_display.text = "Contract Secured."
	else:
		feedback_display.text = "Great! $10 earned."

func handle_failure():
	feedback_display.text = "Wrong order! No tip."

func update_ui():
	order_display.text = "ORDER: " + ", ".join(current_order)
	mix_display.text = "YOUR MIX: " + ", ".join(player_mix)

func end_shift():
	print("Shift ended. Heading to the night phase.")
	GameManager.switch_phase()
