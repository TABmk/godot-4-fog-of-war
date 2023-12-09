extends CharacterBody2D

@export var speed = 500
@export var acceleration = 0.4

func get_input():
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	return Vector2(horizontal, vertical)

func _physics_process(_delta):
	var direction = get_input()
	velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	move_and_slide()
