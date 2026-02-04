extends Node2D

func _ready():
	print("Night Phase Started.")
	if GameManager.active_contract:
		print("Objective: Eliminate ", GameManager.active_contract["target_name"])
	else:
		print("No active contract. Scout the area for intel.")

func _process(_delta):
	# Check if the target is still in the scene
	var target = get_node_or_null("TargetEnemy")
	if GameManager.active_contract and target == null:
		mission_complete()

func mission_complete():
	print("Target eliminated! Mission successful.")
	GameManager.add_cash(GameManager.active_contract["reward"])
	# Delay before switching back to day
	set_process(false)
	await get_tree().create_timer(3.0).timeout
	GameManager.switch_phase()
