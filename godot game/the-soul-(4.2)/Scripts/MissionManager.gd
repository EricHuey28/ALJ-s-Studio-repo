extends Node2D

var enemies_container
var mission_complete = false
var lbl_status
var btn_return

func _ready():
	# UI Setup
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	lbl_status = Label.new()
	lbl_status.text = "MISSION IN PROGRESS"
	lbl_status.position = Vector2(20, 20)
	lbl_status.modulate = Color.RED
	canvas_layer.add_child(lbl_status)
	
	btn_return = Button.new()
	btn_return.text = "RETURN TO SHOP"
	btn_return.position = Vector2(20, 60)
	btn_return.visible = false
	btn_return.pressed.connect(_on_return_pressed)
	canvas_layer.add_child(btn_return)
	
	enemies_container = get_node("Enemies")

func _process(delta):
	if not mission_complete:
		if enemies_container.get_child_count() == 0:
			mission_complete = true
			on_mission_complete()

func on_mission_complete():
	lbl_status.text = "MISSION COMPLETE - TARGET ELIMINATED"
	lbl_status.modulate = Color.GREEN
	btn_return.visible = true
	GameManager.add_money(100) # Mission reward

func _on_return_pressed():
	GameManager.start_shop()
	get_tree().change_scene_to_file("res://Scenes/ShopScene.tscn")
