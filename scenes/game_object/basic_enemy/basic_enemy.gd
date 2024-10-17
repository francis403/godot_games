extends CharacterBody2D

@onready var visuals_node = $Visuals
@onready var velocity_component = $VelocityComponent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	# turn the sprite around	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals_node.scale = Vector2(-move_sign, 1)


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node == null:
		return Vector2.ZERO
	return (player_node.global_position - self.global_position).normalized()
