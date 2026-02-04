extends Node

# Game States
enum Phase { DAY, NIGHT }
var current_phase = Phase.DAY

# Player Stats
var cash: int = 0
var intel: int = 0
var day_number: int = 1

# Contract Data
var active_contract = null # { "target_name": String, "reward": int }

func _ready():
	print("GameManager: Initialized. Day 1.")

func switch_phase():
	if current_phase == Phase.DAY:
		current_phase = Phase.NIGHT
		get_tree().change_scene_to_file("res://Scenes/NightPhase.tscn")
	else:
		current_phase = Phase.DAY
		day_number += 1
		active_contract = null # Reset contract for the new day
		get_tree().change_scene_to_file("res://Scenes/DayPhase.tscn")

func add_cash(amount: int):
	cash += amount
	print("Cash: $", cash)

func set_contract(target: String, reward: int):
	active_contract = {"target_name": target, "reward": reward}
	print("New Contract: ", target)
