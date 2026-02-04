extends Area2D

var speed = 600
var direction = Vector2.ZERO

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10 * GameManager.player_damage_multiplier)
		queue_free()
	elif body.name != "Player": # Hit wall
		queue_free()
