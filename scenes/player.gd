extends CharacterBody2D

const SPEED = 100
var direction : Vector2 = Vector2.ZERO
var last_direction : Vector2 = Vector2.ZERO

var WalkSound = preload("res://sounds/Step.mp3")

func _ready():
	$AnimatedSprite2D.play("front_idle")
	# Get the tilemap node and its properties
	var tilemap = get_parent().get_node("Base")
	var tilemap_rect = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size

	$Camera2D.limit_left = tilemap_rect.position.x * tile_size.x
	$Camera2D.limit_right = tilemap_rect.end.x * tile_size.x
	$Camera2D.limit_top = tilemap_rect.position.y * tile_size.y
	$Camera2D.limit_bottom = tilemap_rect.end.y * tile_size.y

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	if direction != Vector2.ZERO:
		last_direction = direction
		if !$AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.stream = WalkSound
			$AudioStreamPlayer2D.pitch_scale = randf_range(0.7, 0.8)
			$AudioStreamPlayer2D.play()
	play_anim(last_direction, direction != Vector2.ZERO)
	move_and_slide()


func play_anim(direction: Vector2, moving: bool) -> void:
	var animation = $AnimatedSprite2D
	animation.flip_h = direction.x < 0
	var anim_type = "walk" if moving else "idle"
	if abs(direction.x) > 0:
		animation.play("side_" + anim_type)
	elif direction.y > 0:
		animation.play("front_" + anim_type)
	elif direction.y < 0:
		animation.play("back_" + anim_type)
	else:
		animation.play("front_idle")
