extends Node

#Half of the greatest dimension of our window + CONSTANT
const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	
#	# prep the weight table
	enemy_table.add_item(basic_enemy_scene, 10)
	

func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO

	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		var additional_check_offset = random_direction * 20
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
			
	#	Raycast check - the 1 is the bit value of the terrain mask (1 << 0)
		var query_parameters = PhysicsRayQueryParameters2D.create(
			player.global_position,
			spawn_position + spawn_position,
			1
		)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if result.is_empty():
			# We are clear
			return spawn_position
		else:
			# Change the angle of the random direction
			random_direction = random_direction.rotated(deg_to_rad(90))
	return spawn_position
	
func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate()
	#get_parent().add_child(enemy)
	#enemy.global_position = spawn_position
	add_enemy_to_game(enemy, get_spawn_position())

func add_enemy_to_game(enemy: Node, spawn_position: Vector2):
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null:
		print("Entities Layer is null")
		pass
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position
	
func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.1/12) * arena_difficulty
	time_off = min(time_off, .7)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 6:
		print("adding wizard...")
		enemy_table.add_item(wizard_enemy_scene, 20)
