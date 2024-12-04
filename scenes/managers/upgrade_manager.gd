extends Node

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

#Stores all the available upgrades to be selected
var upgrade_pool: WeightedTable = WeightedTable.new()

var axe_upgrade = preload("res://resources/upgrades/axe.tres")
var axe_damage_upgrade = preload("res://resources/upgrades/axe_damage.tres")
var sword_damage_upgrade = preload("res://resources/upgrades/sword_damage.tres")
var sword_rate_upgrade = preload("res://resources/upgrades/sword_rate.tres")
var player_speed_upgrade = preload("res://resources/upgrades/player_speed.tres")

#Store all upgrades
var current_upgrades = {}


func _ready() -> void:
	# populate weighted table
	upgrade_pool.add_item(axe_upgrade, 10)
	upgrade_pool.add_item(sword_damage_upgrade, 10)
	upgrade_pool.add_item(sword_rate_upgrade, 10)
	upgrade_pool.add_item(player_speed_upgrade, 5)
	
	# listen to signals
	experience_manager.level_up.connect(on_level_up)
	

func apply_upgrade(upgrade: AbilityUpgrade):
	
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

# add unlocked upgrades to the upgrade pool
func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == axe_upgrade.id:
		upgrade_pool.add_item(axe_damage_upgrade, 10)
		print("adding axe upgrade damage")

func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 2:
		if chosen_upgrades.size() == upgrade_pool.items.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades) as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		# Returns a new array with everything but the chosen upgrade
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
	
	
func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrade(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
