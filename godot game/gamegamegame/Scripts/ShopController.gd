extends Node2D

var current_order = []
var current_mix = []
var is_customer_waiting = false
var order_description = ""

# UI Elements (References to the new Map-based UI)
@onready var ui_interaction = $UI_Layer/InteractionLabel
@onready var ui_boba_panel = $UI_Layer/BobaPanel
@onready var ui_upgrade_panel = $UI_Layer/UpgradePanel
@onready var ui_mission_panel = $UI_Layer/MissionPanel
@onready var player = $Player

var active_zone = null

# Labels for Boba Panel
var lbl_info: Label
var lbl_order: Label
var lbl_mix: Label

func _ready():
	setup_boba_ui()
	setup_upgrade_ui()
	setup_mission_ui()
	
	# Connect zone signals
	$CounterZone.area_entered.connect(_on_zone_entered.bind("counter"))
	$CounterZone.area_exited.connect(_on_zone_exited)
	$UpgradeZone.area_entered.connect(_on_zone_entered.bind("upgrade"))
	$UpgradeZone.area_exited.connect(_on_zone_exited)
	$MissionZone.area_entered.connect(_on_zone_entered.bind("mission"))
	$MissionZone.area_exited.connect(_on_zone_exited)
	
	$UI_Layer/BobaPanel/CloseBoba.pressed.connect(func(): ui_boba_panel.visible = false)
	$UI_Layer/UpgradePanel/CloseUpgrade.pressed.connect(func(): ui_upgrade_panel.visible = false)
	$UI_Layer/MissionPanel/CloseMission.pressed.connect(func(): ui_mission_panel.visible = false)
	
	spawn_customer()

func _process(delta):
	if active_zone and Input.is_action_just_pressed("interact"):
		open_active_panel()

func _on_zone_entered(area, zone_name):
	active_zone = zone_name
	ui_interaction.text = "Press 'E' to use " + zone_name
	ui_interaction.visible = true

func _on_zone_exited(area):
	active_zone = null
	ui_interaction.visible = false

func open_active_panel():
	ui_boba_panel.visible = (active_zone == "counter")
	ui_upgrade_panel.visible = (active_zone == "upgrade")
	ui_mission_panel.visible = (active_zone == "mission")
	
	if active_zone == "mission":
		# Only show mission button if special order received
		var btn = $UI_Layer/MissionPanel/StartBtn
		btn.visible = GameManager.target_order_received

func setup_boba_ui():
	var p = ui_boba_panel
	
	# Header
	var header = Label.new()
	header.text = "--- BOBA MIXING STATION ---"
	header.horizontal_alignment = 1
	header.position = Vector2(0, 10)
	header.size = Vector2(400, 30)
	p.add_child(header)
	
	lbl_info = Label.new()
	lbl_info.position = Vector2(20, 40)
	lbl_info.modulate = Color(0.8, 1, 0.8)
	p.add_child(lbl_info)
	
	# Order Panel Background
	var order_bg = ColorRect.new()
	order_bg.color = Color(0, 0, 0, 0.3)
	order_bg.position = Vector2(10, 70)
	order_bg.size = Vector2(380, 80)
	p.add_child(order_bg)
	
	lbl_order = Label.new()
	lbl_order.position = Vector2(20, 75)
	lbl_order.autowrap_mode = TextServer.AUTOWRAP_WORD
	lbl_order.size = Vector2(360, 70)
	lbl_order.add_theme_color_override("font_color", Color(1, 0.9, 0.5))
	p.add_child(lbl_order)
	
	lbl_mix = Label.new()
	lbl_mix.position = Vector2(20, 160)
	lbl_mix.add_theme_color_override("font_color", Color(0.5, 0.8, 1))
	p.add_child(lbl_mix)
	
	# Ingredients Grid
	var grid = GridContainer.new()
	grid.columns = 2
	grid.position = Vector2(50, 200)
	grid.add_theme_constant_override("h_separation", 20)
	grid.add_theme_constant_override("v_separation", 10)
	p.add_child(grid)
	
	var ingredients = {
		"Tea": Color(0.8, 0.6, 0.4),    # Lighter Amber/Brown
		"Milk": Color(0.95, 0.95, 1.0), # Crisp White
		"Tapioca": Color(0.6, 0.6, 0.6), # Greyish (visible black)
		"Poison": Color(0.8, 0.4, 1.0)  # Brighter Purple
	}
	
	for ing in ingredients:
		var btn = Button.new()
		btn.text = "Add " + ing
		btn.custom_minimum_size = Vector2(140, 40)
		btn.add_theme_color_override("font_color", ingredients[ing])
		btn.pressed.connect(func(): _add_ingredient(ing))
		grid.add_child(btn)
		
	# Actions
	var serve = Button.new()
	serve.text = "SERVE DRINK"
	serve.position = Vector2(50, 310)
	serve.custom_minimum_size = Vector2(140, 50)
	serve.modulate = Color(0.2, 1, 0.2)
	serve.pressed.connect(_on_serve_pressed)
	p.add_child(serve)
	
	var clear = Button.new()
	clear.text = "CLEAR"
	clear.position = Vector2(210, 310)
	clear.custom_minimum_size = Vector2(140, 50)
	clear.modulate = Color(1, 0.2, 0.2)
	clear.pressed.connect(_on_clear_pressed)
	p.add_child(clear)
	
	update_info_label()

func _on_clear_pressed():
	current_mix = []
	update_mix_label()

func setup_upgrade_ui():
	var p = ui_upgrade_panel
	var btn = Button.new()
	btn.text = "Upgrade Boba Launcher ($50)"
	btn.position = Vector2(50, 80)
	btn.pressed.connect(_on_upgrade_pressed)
	p.add_child(btn)

func setup_mission_ui():
	var p = ui_mission_panel
	var lbl = Label.new()
	lbl.text = "Contracts"
	lbl.position = Vector2(100, 20)
	p.add_child(lbl)
	
	var btn = Button.new()
	btn.name = "StartBtn"
	btn.text = "START MISSION"
	btn.position = Vector2(80, 80)
	btn.pressed.connect(_on_start_mission_pressed)
	p.add_child(btn)

func update_info_label():
	if lbl_info:
		lbl_info.text = "Day: %d | Money: $%d" % [GameManager.day, GameManager.money]

func spawn_customer():
	current_mix = []
	update_mix_label()
	is_customer_waiting = true
	var possible_ingredients = ["Tea", "Milk", "Tapioca"]
	current_order = []
	order_description = "Order: "
	var count = randi() % 2 + 2 
	for i in range(count):
		var ing = possible_ingredients.pick_random()
		current_order.append(ing)
		order_description += ing + " "
	if randf() < 0.4:
		order_description += "\n\n[!] SPECIAL ORDER: 'The Owl flies at midnight.'"
		GameManager.target_order_received = true
	lbl_order.text = order_description

func _add_ingredient(ing):
	current_mix.append(ing)
	update_mix_label()

func update_mix_label():
	if lbl_mix:
		lbl_mix.text = "Mix: " + str(current_mix)

func _on_serve_pressed():
	if not is_customer_waiting: return
	var correct = (current_mix == current_order)
	if correct:
		GameManager.add_money(15)
		lbl_order.text = "Customer: Delicious!"
	else:
		lbl_order.text = "Customer: Awful..."
	is_customer_waiting = false
	update_info_label()
	await get_tree().create_timer(1.0).timeout
	spawn_customer()

func _on_upgrade_pressed():
	if GameManager.money >= 50:
		GameManager.money -= 50
		GameManager.player_damage_multiplier += 0.5
		update_info_label()
	else:
		print("Need more cash")

func _on_start_mission_pressed():
	GameManager.start_mission()
	get_tree().change_scene_to_file("res://Scenes/MissionScene.tscn")
