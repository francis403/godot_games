extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var random_stream_player_2d_component = $RandomStreamPlayer2DComponent 


func _ready() -> void:
	$Area2D.area_entered.connect(on_area_enter)
	
func on_area_enter(other_area: Area2D):
	# call outside the physics handling (call on next frame)
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(self.global_position), 0.0, 1.0, .5)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
		
	tween.tween_property(sprite, "scale", Vector2.ZERO, .05).set_delay(.45)
	tween.chain()
	tween.tween_callback(collect)
	
	random_stream_player_2d_component.play_random()

func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()

func disable_collision():
	collision_shape_2d.disabled = true

# TWEEN FUNCTIONS
func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	self.global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	self.rotation = \
		lerp_angle(\
			rotation,\
			target_rotation,\
			1 - exp(-2 * get_process_delta_time())\
		)
	
# END TWEEN FUNCTIONS
